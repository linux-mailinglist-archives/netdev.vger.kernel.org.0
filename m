Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F0D6D15A8
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 04:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjCaCe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 22:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCaCe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 22:34:26 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561C761B7;
        Thu, 30 Mar 2023 19:34:25 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r11so84247414edd.5;
        Thu, 30 Mar 2023 19:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680230064; x=1682822064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vcs8c2BEfAg672V0yocp3KLubt3IJ7dsRgOCNV149Ug=;
        b=QpBZVsU95jX3aZbO3OsYIk19lIKzbzZC4Vvd5dwFMZ+gUJpGN6pwcbxmsqCZx/6Dry
         K865IBiuFhkv2DLasa7bsbZ3sP6KtwvKp1IxhBun8jppXI7E3tIpKJYUTTTs+GjqjHGL
         AV9dVdJfNjGZG8o4a9I95t/j4S+R1nVT9mLPQaIiowGSIKmaTZV/qxTqIe17XS1mUmlI
         kt+Xn4Vmx8GOTknUONEIFjx+YFUR/uDAHeHyElbqQ/zucbMpEpJgSQbPD8bbu+FjuUop
         IH2GUHwuICvF8HpTeCh+zaDN4520yy/RE6N/oUhxi150DA8Jjy+4UfBGhTl+9NpRTpLP
         33tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680230064; x=1682822064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vcs8c2BEfAg672V0yocp3KLubt3IJ7dsRgOCNV149Ug=;
        b=UgBYzJhATteNNe9WIAFkPLkvOGaGkMdU8cWjoey473NmPqoEY/s2c8iQnyka1uiHND
         VLhndJur/swkxBOaz9G2eq6guZL0D/9X48PUDw4bp3yp/xv9fmXxf2SBvVyTueox1IGK
         zvFT8+A60IkPKmxPVJfv390vfJG9t0eNUJwUaIvbnlB1KjoYNgdHZLpDjkM3UIG8YUtu
         ADLCb20yU3thF1YGtL89iEhFt01gU66YStugMiQZ2vGmSZneTDPZbM9+QI+/xVM+VC8r
         uga5h2A6jFPWc/veU7tFpQIZY0XgOMwgXU+FTz3Jyzp/7WnKM2o2saASQWDpJN1kIihC
         TOKg==
X-Gm-Message-State: AAQBX9ectZMtE+LcRDddy+bzIiRIhsaLHG4QIlANgnOBGY7i42lMCWAP
        OxYA/eexZCela+fJ7TGYlzf0NN4VC9sZvxGVb/Q=
X-Google-Smtp-Source: AKy350Zb65WfoEVijwKalbM5ODB2ISBZEuPtmp93KTO9gTV3zgm+MDVN95+bdXUfQS6b6Lf+FRSpF+vGeipjXUftAd8=
X-Received: by 2002:a17:907:d412:b0:930:310:abbf with SMTP id
 vi18-20020a170907d41200b009300310abbfmr12636671ejc.11.1680230063707; Thu, 30
 Mar 2023 19:34:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
 <20230315092041.35482-3-kerneljasonxing@gmail.com> <20230316172020.5af40fe8@kernel.org>
 <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
 <20230316202648.1f8c2f80@kernel.org> <CAL+tcoCRn7RfzgrODp+qGv_sYEfv+=1G0Jm=yEoCoi5K8NfSSA@mail.gmail.com>
 <20230330092316.52bb7d6b@kernel.org> <CAL+tcoBKiVqETEAPPawLbS_OF0Eb6HgZRHe-=W81bVKCkpr4Rg@mail.gmail.com>
 <20230330192050.1e057776@kernel.org>
In-Reply-To: <20230330192050.1e057776@kernel.org>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 31 Mar 2023 10:33:47 +0800
Message-ID: <CAL+tcoC=YU7DT0KAeZ-Kw==jvhBsMDpnXxUsAsCtuPttzedNgg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:20=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Fri, 31 Mar 2023 08:48:07 +0800 Jason Xing wrote:
> > On Fri, Mar 31, 2023 at 12:23=E2=80=AFAM Jakub Kicinski <kuba@kernel.or=
g> wrote:
> > > On Thu, 30 Mar 2023 17:59:46 +0800 Jason Xing wrote:
> > > > I'm wondering for now if I can update and resend this patch to have=
 a
> > > > better monitor (actually we do need one) on this part since we have
> > > > touched the net_rx_action() in the rps optimization patch series?
> > > > Also, just like Jesper mentioned before, it can be considered as on=
e
> > > > 'fix' to a old problem but targetting to net-next is just fine. Wha=
t
> > > > do you think about it ?
> > >
> > > Sorry, I don't understand what you're trying to say :(
> >
> > Previously this patch was not accepted because we do not want to touch
> > softirqs (actually which is net_rx_action()). Since it is touched in
> > the commit [1] in recent days, I would like to ask your permission:
> > could I resend this patch to the mailing list? I hope we can get it
> > merged.
> >
> > This patch can be considered as a 'fix' to the old problem. It's
> > beneficial and harmless, I think :)
>
> The not touching part was about softirqs which is kernel/softirq.c,
> this patch was rejected because it's not useful.

But...but time_squeeze here is really vague and it doesn't provide any
useful information to those user-side tools, which means we cannot
conclude anything from this output if we have to trace back to the
history of servers.

Right now, time_squeeze looks abandoned but many applications still
rely on it. It's not proper :(

Thanks,
Jason
