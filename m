Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653977E654
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 01:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732626AbfHAXP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 19:15:59 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34997 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbfHAXP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 19:15:59 -0400
Received: by mail-yb1-f194.google.com with SMTP id p85so13625026yba.2
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 16:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=06Xjl8xwVElD8TuadDbhO8wIkDa5jiIzMLYGbCJ3IQM=;
        b=F/+sle/fJAUc8KeIW+463HFv2iEswCUDe0Le+Vpa4TxfuKdzpeleEYMIfoeb0K8rIc
         7QXiBPPdWrJhKSTjcGREsRP60wmlUSpbHtC+/mLrsiJo9NbNtQYQmU2HJidAoxJ5K/R5
         mKTHFeWOdm/MkCRoKVwdVQahn/1ZtB17tOhEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=06Xjl8xwVElD8TuadDbhO8wIkDa5jiIzMLYGbCJ3IQM=;
        b=TPze3mHO3eV1ZFcGZE99uTqsVPfmkTa4t/YgKehxCMqSJSzgG9zXI2DidgTl80QHWx
         RsjBV92EJuhomarM9/2IILtbos+/bQYB0KoC0ULc8NbiyuGycoM1vxBKOieqIdyincu4
         qfDv/6sIf0C8um7TJtvgii2bhVYWukgIAIHyhxve5hjErR/aBXQ9EFLEp6J4uaZY47p5
         jSws03UjLHHdrNYYJsR27YHUkZKtqE74srv0dEZltohJV20keZOzBCfqSwwh+WAmO6wh
         i/4Cnqr/ax30fsYERq0ddLovJRpTpjLTKfG8TsPhil/shH7nnKYjhYmA58GzSTIxMCrp
         MeLQ==
X-Gm-Message-State: APjAAAXsBvBsIyzuyhyCgrGZjrSzSr43/uJ0156CXngDbc92WWf/2jKA
        vDs4WvTIl+Duq2BW+cDHO2Jn8jprBYwt8xb5dApR1w==
X-Google-Smtp-Source: APXvYqymJLYJBEWw5p4DhtooQ8mDGh029PXr4gbweTcKgJnidReKSoTRPoK/0zMnFXIx/KJZcYFVG1r+s1cW2/q9/UA=
X-Received: by 2002:a25:85:: with SMTP id 127mr84946065yba.186.1564701358458;
 Thu, 01 Aug 2019 16:15:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190731122224.1003-1-hslester96@gmail.com> <CACKFLinuFebDgJN=BgK5e-bNaFqNpk61teva0=2xMH6R_iT39g@mail.gmail.com>
 <CANhBUQ1J8hXBZv4x3pJhG_08ZS1zR=9Uj2EUta2sgtyND_QKPw@mail.gmail.com>
In-Reply-To: <CANhBUQ1J8hXBZv4x3pJhG_08ZS1zR=9Uj2EUta2sgtyND_QKPw@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 1 Aug 2019 16:15:47 -0700
Message-ID: <CACKFLi=r11QYhMbO56EDY4mNOB_x3jkR-_zWh8hg_-GL-=t0rg@mail.gmail.com>
Subject: Re: [PATCH 2/2] cnic: Use refcount_t for refcount
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 7:22 PM Chuhong Yuan <hslester96@gmail.com> wrote:
>
> Michael Chan <michael.chan@broadcom.com> =E4=BA=8E2019=E5=B9=B48=E6=9C=88=
1=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=881:58=E5=86=99=E9=81=93=EF=BC=
=9A
> >
> > On Wed, Jul 31, 2019 at 5:22 AM Chuhong Yuan <hslester96@gmail.com> wro=
te:
> >
> > >  static void cnic_ctx_wr(struct cnic_dev *dev, u32 cid_addr, u32 off,=
 u32 val)
> > > @@ -494,7 +494,7 @@ int cnic_register_driver(int ulp_type, struct cni=
c_ulp_ops *ulp_ops)
> > >         }
> > >         read_unlock(&cnic_dev_lock);
> > >
> > > -       atomic_set(&ulp_ops->ref_count, 0);
> > > +       refcount_set(&ulp_ops->ref_count, 0);
> > >         rcu_assign_pointer(cnic_ulp_tbl[ulp_type], ulp_ops);
> > >         mutex_unlock(&cnic_lock);
> > >
> >
> > Willem's comment applies here too.  The driver needs to be modified to
> > count from 1 to use refcount_t.
> >
> > Thanks.
>
> I have revised this problem but find the other two refcounts -
> cnic_dev::ref_count
> and cnic_sock::ref_count have no set.
> I am not sure where to initialize them to 1.
>
> Besides, should ulp_ops->ref_count be set to 0 when unregistered?

I will send a patch to fix up the initialization of all the atomic ref
counts.  After that, you can add your patch to convert to refcount_t.
