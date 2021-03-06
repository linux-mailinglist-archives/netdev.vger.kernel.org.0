Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A0B32FE05
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 00:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhCFXff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 18:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhCFXfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 18:35:19 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C74FC06174A;
        Sat,  6 Mar 2021 15:35:18 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id d20so6939613oiw.10;
        Sat, 06 Mar 2021 15:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HTaNUUaToaDrVihiXPvalyzf1gp0a+sOljx+Ntsz1r4=;
        b=WJXand+p0M+rWIQUG+OrX6zKJB/aZFsI19+Yjj3BxloEMdVFyhRS5XgSzfV1nYqsNE
         uKEr+yU03d5MeLbSgPV2si9sV7VAPv95yITYkMC8cb+ax3ve0EvkzNWT2HVwZVHuCLvp
         TP6PN2Py2RaGyeS68Y7UGEotaKWp2xdsgq+xJ4QXM3QBtmkMEnI0cFe30pJhQA96NIsS
         9muQN7rPYSdoHah5G6hYQxm2fbEksDAMYsyIZ/4N6fZE7hy4eDyz2VyNUl8his/AAzfR
         8HV+NfQ+ZiZTm4lX7cXuV4bACfIHBaLoHVh51VrQFg83lxDZ8DiuSG0cGzVQtBrBrJO+
         B+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HTaNUUaToaDrVihiXPvalyzf1gp0a+sOljx+Ntsz1r4=;
        b=HiOcEtL4henWrOUg4soXHVHhX1XzQ1u6g1TmOJCE0b/FGCa8HiGRp4IgJDwFdpXLQy
         DWcrGEXcrJqBHB70joALQ1rCb542wpApXUhbLP2/e5eh6XcLPMmgjcLNp1Y2xxOkNQ79
         WEUkH5feEfSNUV8xXjg/YB+jk8rXfq5Jk6qxY5TgpnEAp/Y6ju3zUK4cN+z+/URGBYVF
         Vc/DVpykMs4k19fX/QwZDgkL/OaVpc7eFLCYNyUy6eTeUVbyggG+V+W9abR6+OhuBKAy
         J+M6+1WU6zsKMErGn7oyxCGpTvEjs7LOQ++UJYasbfQVnkBVdnQHp4gZSTc/jNQgrvHN
         WXOQ==
X-Gm-Message-State: AOAM5307DiP84Q4XyAEijYvHsP3QS9TLiIkdBxzBmzikLZ9VL/HwDJT9
        pE/LEK+VJcj5Lv6gR9PHzd02K3ASIL49TUAAc2CNzg3jcpo=
X-Google-Smtp-Source: ABdhPJwYE1jmc5l5+PfAiYiw9w/wupm4lJpcSe6eHlzJ4Ga91wfPJHQW2YyW+iFYYxHQiwofcnfN1MRzb7NOmHpe4iY=
X-Received: by 2002:aca:3dd7:: with SMTP id k206mr12200383oia.10.1615073717576;
 Sat, 06 Mar 2021 15:35:17 -0800 (PST)
MIME-Version: 1.0
References: <20210228151817.95700-1-aahringo@redhat.com> <20210228151817.95700-2-aahringo@redhat.com>
 <b9baaf49-0e25-4c74-e8b7-f826157e1d48@datenfreihafen.org>
In-Reply-To: <b9baaf49-0e25-4c74-e8b7-f826157e1d48@datenfreihafen.org>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sat, 6 Mar 2021 18:35:06 -0500
Message-ID: <CAB_54W6d0NC7W3U6EMOR7RxYGQhJS_hAFcgRcrpM5W7BC7SXXg@mail.gmail.com>
Subject: Re: [PATCH wpan 01/17] net: ieee802154: make shift exponent unsigned
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <aahringo@redhat.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On Thu, 4 Mar 2021 at 02:28, Stefan Schmidt <stefan@datenfreihafen.org> wrote:
>
> Hello Alex.
>
> On 28.02.21 16:18, Alexander Aring wrote:
> > This patch changes the iftype type variable to unsigned that it can
> > never be reach a negative value.
> >
> > Reported-by: syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com
> > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > ---
> >   net/ieee802154/nl802154.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > index e9e4652cd592..3ee09f6d13b7 100644
> > --- a/net/ieee802154/nl802154.c
> > +++ b/net/ieee802154/nl802154.c
> > @@ -898,8 +898,8 @@ static int nl802154_get_interface(struct sk_buff *skb, struct genl_info *info)
> >   static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
> >   {
> >       struct cfg802154_registered_device *rdev = info->user_ptr[0];
> > -     enum nl802154_iftype type = NL802154_IFTYPE_UNSPEC;
> >       __le64 extended_addr = cpu_to_le64(0x0000000000000000ULL);
> > +     u32 type = NL802154_IFTYPE_UNSPEC;
> >
> >       /* TODO avoid failing a new interface
> >        * creation due to pending removal?
> >
>
> I am concerned about this one. Maybe you can shed some light on it.
> NL802154_IFTYPE_UNSPEC is -1 which means the u32 will not hold this
> value, but something at the end of the range for u32.
>

yes, ugh... it's NL802154_IFTYPE_UNSPEC = -1 only for
NL802154_IFTYPE... all others UNSPEC are 0. There is a comment there
/* for backwards compatibility TODO */. I think I did that because the
old netlink interfaces and instead of mapping new values to old values
(internally) which is bad.
Would it be 0 I think the compiler would handle it as unsigned.

> There is a path (info->attrs[NL802154_ATTR_IFTYPE] is not true) where we
> put type forward to  rdev_add_virtual_intf() with its changed value but
> it would expect and enum which could hold -1 for UNSPEC.
>

It will be converted back here to -1 again? Or maybe depends on the
compiler, because it may use a different int type which the enum
values fits? I am not sure here...

In nl802154 we use u32 (netlink) for enums because the range fits,
however this isn't true for NL802154_IFTYPE_, we cannot change it
back. I think we should try to switch NL802154_IFTYPE_UNSPEC to
"(~(__u32)0)" and let start NL802154_IFTYPE_NODE = 0. Which is still
backwards compatible. Just give the compiler a note to handle it as
unsigned value and more importantly an enum where the range fits in.
It depends on the compiler, may it decide to use a signed char for
this enum, then we get problems when converting it ? After quick
research it seems we can not rely on whatever the compiler handles the
enum as signed or unsigned and that makes problems with the shift
operator "BIT(type)" and it's what this patch is trying to fix. I
would make two patches, one is making the nl802154.h changes and the
other is this patch, should be fine to handle it as enum value when we
did some max range checks.

There is also a third patch to return -EINVAL earlier if type attr
isn't given, I think it's nothing for stable.

- Alex
