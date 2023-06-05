Return-Path: <netdev+bounces-8076-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB099722A00
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6354D1C208FF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5C51F953;
	Mon,  5 Jun 2023 14:48:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8881EA94
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:48:31 +0000 (UTC)
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF219C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:48:30 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-7748d634a70so187188539f.2
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 07:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685976509; x=1688568509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D7z3LgxAgc5Q57u9cRrMNQvbY7VHRXu9d6c5Wvc4Pew=;
        b=GV54qYz5iaJryJLfF45WJIW4Etvr0wnPHxbJ8IQLyqQzgtDvtd3MDP9Hj4ZiEfcDKN
         qUcRidNo9N0Aa9kR94jadV6cGIGPN1Yxkj/WMppnoz6LxfCqrCKjn1tikowJr4eL0zXU
         SUaSykfANMzO8Z35II60exY1GLXo3CbM0SY5CMPkd3g5Q0AZHYthgrnLLzl77/0YuiJb
         rWzOT+IwvSIcaMd8Op/+CTHhZbRNxxkmNebbhhqj2TMZMLhJ8FDYHzQsNlY9g3bRjKNC
         lkihg5cD6NPwIoar70HbhPiJbQqC882UDUUmT+kxXbD5U5ksW2GIyqkdR5x9V5ic4f6q
         2Y0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685976509; x=1688568509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D7z3LgxAgc5Q57u9cRrMNQvbY7VHRXu9d6c5Wvc4Pew=;
        b=CpoQB3ioeZS5yWJY07zXsAm7X+IcUrPa5K6TnxOS36NWVwxdIX+7uhCq3Yi+ZRnJ7p
         6SuZRBybGLRhQ7nfphuFfICBGblNqu83w8vPmpTeSKVXzYkkDJy0vsnIYZbVVfyf/yJb
         tTAhuI6kpEkCjPahxAJJ+0uYJExkPUsbN01qkhuh3OFzEvXEADi/0oeyWRkjIRot4kAb
         GutP+iiM/3SBUtUsT7+yoql4SpGX8IbbViA96gMNXoNWl5kCTcLxRNHIc7aEqCszKNXF
         nRRdThR26dG0sDjWmLhS674MNDXAG3ClJGXACpLEvb1zROFbBRxtFz75TN7nn/MQ/eFn
         vkfA==
X-Gm-Message-State: AC+VfDzsQRISAPq6elFm4zsFGdYMzRTwB9cGRAud2wDpYS4OQBBC1zHD
	tsvbJrrZH0NhTOz5zr/U+ChBGstWbXQMp3Y0ovEK0w==
X-Google-Smtp-Source: ACHHUZ5mNqjzw2++wtEyn2emqC5Xd5utNphmN6/nuQMyIH2NW5qfNG1t3+kcyRvGwS8R7QA/O39dFZesxbtA8lffFkc=
X-Received: by 2002:a05:6602:220b:b0:776:fa15:2898 with SMTP id
 n11-20020a056602220b00b00776fa152898mr112704ion.5.1685976509017; Mon, 05 Jun
 2023 07:48:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-12-jhs@mojatatu.com>
 <ZH23+403sRcabGa5@corigine.com>
In-Reply-To: <ZH23+403sRcabGa5@corigine.com>
From: Jamal Hadi Salim <hadi@mojatatu.com>
Date: Mon, 5 Jun 2023 10:48:18 -0400
Message-ID: <CAAFAkD-=hLQzZoPtuvc0aaV8pOd8b=z2G8bYqsqM7qdKUeSB=g@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 12/28] p4tc: add
 header field create, get, delete, flush and dump
To: Simon Horman <simon.horman@corigine.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org, deb.chatterjee@intel.com, 
	tom@sipanda.io, p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com, 
	Vipin.Jain@amd.com, tomasz.osinski@intel.com, xiyou.wangcong@gmail.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 6:25=E2=80=AFAM Simon Horman via p4tc-discussions
<p4tc-discussions@netdevconf.info> wrote:
>
> On Wed, May 17, 2023 at 07:02:16AM -0400, Jamal Hadi Salim wrote:
>
> ...
>
> Hi Victor, Pedro and Jamal,
>
> some minor feedback from my side.
>
> > +static int _tcf_hdrfield_fill_nlmsg(struct sk_buff *skb,
> > +                                 struct p4tc_hdrfield *hdrfield)
> > +{
> > +     unsigned char *b =3D nlmsg_get_pos(skb);
> > +     struct p4tc_hdrfield_ty hdr_arg;
> > +     struct nlattr *nest;
> > +     /* Parser instance id + header field id */
> > +     u32 ids[2];
> > +
> > +     ids[0] =3D hdrfield->parser_inst_id;
> > +     ids[1] =3D hdrfield->hdrfield_id;
> > +
> > +     if (nla_put(skb, P4TC_PATH, sizeof(ids), ids))
> > +             goto out_nlmsg_trim;
> > +
> > +     nest =3D nla_nest_start(skb, P4TC_PARAMS);
> > +     if (!nest)
> > +             goto out_nlmsg_trim;
> > +
> > +     hdr_arg.datatype =3D hdrfield->datatype;
> > +     hdr_arg.startbit =3D hdrfield->startbit;
> > +     hdr_arg.endbit =3D hdrfield->endbit;
>
> There may be padding at the end of hdr_arg,
> which is passed uninitialised to nla_put below.

Yeah, same comment as the metadata case; we could add initialization
or add PADx at the end. Or maybe there's another approach you had in
mind.

cheers,
jamal
> > +
> > +     if (hdrfield->common.name[0]) {
> > +             if (nla_put_string(skb, P4TC_HDRFIELD_NAME,
> > +                                hdrfield->common.name))
> > +                     goto out_nlmsg_trim;
> > +     }
> > +
> > +     if (nla_put(skb, P4TC_HDRFIELD_DATA, sizeof(hdr_arg), &hdr_arg))
> > +             goto out_nlmsg_trim;
> > +
> > +     nla_nest_end(skb, nest);
> > +
> > +     return skb->len;
> > +
> > +out_nlmsg_trim:
> > +     nlmsg_trim(skb, b);
> > +     return -1;
> > +}
>
> ...
> _______________________________________________
> p4tc-discussions mailing list -- p4tc-discussions@netdevconf.info
> To unsubscribe send an email to p4tc-discussions-leave@netdevconf.info

