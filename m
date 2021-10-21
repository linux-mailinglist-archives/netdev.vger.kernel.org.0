Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEB6436D6D
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhJUW1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhJUW1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 18:27:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE97C061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 15:25:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id np13so1535414pjb.4
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 15:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=agm1M/Pt20H94bS6/vmog5H7Fo8EC7QGdWVgZMsDml8=;
        b=XVIKQ1t2UWHdmOwXR4c9MiY+Y5F/3AnETHxD8HTOkz6fZ9xHqJ2nAVFKbAQnr0nMHk
         8TXv04uw6/uthI19+ido++kuNYDTAgMwz1DzYkP/Z4cEdCxiiiZ+cMWAIcRqufxUyiNr
         6RoKxneVkJwDjO4ovU0RO7u6rmCd8r77ZeGfUZl1TrKOeCa6RWUE2GOHcqG0dymiLK6D
         a7jLTinXUWv79NiofTREYFnGP7CK6b77Z5dYB1eCgiaQCB7aZZGXhQT5u+Y4IJFaquOC
         jpBEmpk5Xi5CFuCGwTvdW3cgwLMFbQrl0EBXMIwZ04BJfe0OsOgNox4Thh7ua0Ky+7RN
         q7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=agm1M/Pt20H94bS6/vmog5H7Fo8EC7QGdWVgZMsDml8=;
        b=uEF+Gkarrn3WxPWYHHZMD+QneoExjMrPdmuS3prb2+kmTkmm3RPFBs8rBwdBb/tbFK
         H0U8RZNq8eUYZuA2W0BeY3UI9wNxSab6//vIJ9zEtzzBi8QGt5r4G5622AMVCIPTs9dG
         Eeu9THb/xygwVQapAYQMKaUmxtLdAVblm0LQaZZSHkyTe0e9S+dadZsuco7eIpHt2ADK
         eUI8DxQBomGcxlv7IWxmsIdX9flkoqiVKrvR4FwuAeNgZCGn3eBr2lORbLCWWujH6STz
         WPzBJfW9Fe3Lt6cWL9SN5yV/khL0gX1hG4kgvY8Aq/ihtgJEbsUgrjYzYChgD7bqJI6N
         RTTQ==
X-Gm-Message-State: AOAM533G+pS4ceAd8179aKjqjWYmJCHxTHDRjz03uHLa6J1XlLfxjBPh
        ZqX6KQvT79WfkT7t8TQnrI63rw==
X-Google-Smtp-Source: ABdhPJy2HUZsyUMJ0Zy9iIJWiPqCsFVkc+93cjKLsxRLOmTTI4Kwvmu0NcZN4tlxwwUb6L3Q7OfqPw==
X-Received: by 2002:a17:90a:4e42:: with SMTP id t2mr9880545pjl.108.1634855129469;
        Thu, 21 Oct 2021 15:25:29 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id u16sm7570353pfi.73.2021.10.21.15.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 15:25:28 -0700 (PDT)
Date:   Thu, 21 Oct 2021 15:25:26 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        antony.antony@secunet.com, steffen.klassert@secunet.com
Subject: Re: [PATCH iproute2 v2] xfrm: enable to manage default policies
Message-ID: <20211021152526.7bda8a8d@hermes.local>
In-Reply-To: <9acfb0e5-872d-e527-9feb-6e9f5cf2f447@6wind.com>
References: <20210923061342.8522-1-nicolas.dichtel@6wind.com>
        <20211018083045.27406-1-nicolas.dichtel@6wind.com>
        <1ee8e8ec-734b-eec7-1826-340c0d48f26e@gmail.com>
        <9acfb0e5-872d-e527-9feb-6e9f5cf2f447@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 23:23:01 +0200
Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> Le 21/10/2021 =C3=A0 16:55, David Ahern a =C3=A9crit=C2=A0:
> > On 10/18/21 2:30 AM, Nicolas Dichtel wrote: =20
> >> diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
> >> index ecd06396eb16..378b4092f26a 100644
> >> --- a/include/uapi/linux/xfrm.h
> >> +++ b/include/uapi/linux/xfrm.h
> >> @@ -213,13 +213,13 @@ enum {
> >>  	XFRM_MSG_GETSPDINFO,
> >>  #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
> >> =20
> >> +	XFRM_MSG_MAPPING,
> >> +#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
> >> +
> >>  	XFRM_MSG_SETDEFAULT,
> >>  #define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
> >>  	XFRM_MSG_GETDEFAULT,
> >>  #define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
> >> -
> >> -	XFRM_MSG_MAPPING,
> >> -#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
> >>  	__XFRM_MSG_MAX
> >>  };
> >>  #define XFRM_MSG_MAX (__XFRM_MSG_MAX - 1)
> >> @@ -514,9 +514,12 @@ struct xfrm_user_offload {
> >>  #define XFRM_OFFLOAD_INBOUND	2
> >> =20
> >>  struct xfrm_userpolicy_default {
> >> -#define XFRM_USERPOLICY_DIRMASK_MAX	(sizeof(__u8) * 8)
> >> -	__u8				dirmask;
> >> -	__u8				action;
> >> +#define XFRM_USERPOLICY_UNSPEC	0
> >> +#define XFRM_USERPOLICY_BLOCK	1
> >> +#define XFRM_USERPOLICY_ACCEPT	2
> >> +	__u8				in;
> >> +	__u8				fwd;
> >> +	__u8				out;
> >>  };
> >> =20
> >>  /* backwards compatibility for userspace */ =20
> >=20
> > that is already updated in iproute2-next. =20
> But this is needed for the iproute2 also. These will be in the linux v5.1=
5 release.

Yes the header is already in iproute2 just not the code to use it.

PS: Need a volunteer to update ip xfrm to print in JSON like the
rest of ip sub commands.
