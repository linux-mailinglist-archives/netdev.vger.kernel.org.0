Return-Path: <netdev+bounces-5933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A0F71366E
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 22:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71E17281629
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 20:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8174A168C6;
	Sat, 27 May 2023 20:36:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A5ED52C
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 20:36:57 +0000 (UTC)
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8E4B1
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:36:53 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 3f1490d57ef6-bacf685150cso3963276276.3
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685219813; x=1687811813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWbgUXfPm7CPofAY8KtxaGNnAh3ytpiLkWVYwLGA308=;
        b=Qlf0VpmJ0ygu88Y04fk0ktx3UiGJhMQmi+oYhUiePSTJ0GVwRwpcZBd7sosvt39R9W
         l81qnQwcSEWfEus+SmLl0j0Yw7RNHsaFiiOgX7pg+xGRm77IjJxMwrphyFA/iuZUGGwx
         ACYyDtbhrPnNIfgU776FD77fZIu5Kq8shx+a8Wxqmn7V5ptVrKH0hByj72xOinfa8sQ1
         IrEVrPGy+EL9Z9eD9eh3+TdeFxykOBA3tQtUgVrcC0fuLo80tJ/la0FDc9XnSilLINHZ
         vm6rWNMcLFaa8zJUAKZD29It4Y2DNbNjCME9RTaSrUr85itUmNWfyAS7GXrWBf6E2Qnz
         AiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685219813; x=1687811813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wWbgUXfPm7CPofAY8KtxaGNnAh3ytpiLkWVYwLGA308=;
        b=eDaiLq4KHFaJkGXUVQbpXLUgP3Za9x+7C4ju9EQfmrstg/QmAi0zAauwOqGhYaG5JB
         bosRniEHkHrAv2ZJAPSHe6oSpbb5CL5Hb5HCQkFpYeVtUXH7eBncP0/enBE9E5t84wzT
         4kIlqVQi/56gAovK30zWCRHd5QDqRLOL03OMDx6ln5N2s4dfwciz4WY2xESUHCIFsNiT
         gk/C1DAZxCuTJ77oheVxBi/9m3ryxxW3ZE3nJQq0gLlSQ2YjFLVTGZRnabANHTje2t4X
         +MrShrjUArb1Uy+53bgbqtxozfbtnR8JU4boiI5n7sDsxq94ArXVZiJtitF/29FndzfH
         itSg==
X-Gm-Message-State: AC+VfDyPEKkoWLYxtH+7QBwGLfPRg0Wej4nthKAOzqapoYoG9ab+ccqt
	au4jm++GzvhjyyAAUDntaru2tCqs395pAjD7bHf/HlMm5Fs=
X-Google-Smtp-Source: ACHHUZ6LdhvI4tAXRDlTXkN/apH6AfaUQijr31vjfRTnHtseujzEosGTpTaUYrZi7senRG6F+dHDzyFuH2cZNaMJ6VI=
X-Received: by 2002:a25:cf96:0:b0:ba7:a8e1:f0eb with SMTP id
 f144-20020a25cf96000000b00ba7a8e1f0ebmr6937664ybg.19.1685219812886; Sat, 27
 May 2023 13:36:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1685051273.git.lucien.xin@gmail.com> <7fde1eac7583cc93bc5b1cb3b386c522b32a94c9.1685051273.git.lucien.xin@gmail.com>
 <20230526204956.4cc0ddf3@kernel.org>
In-Reply-To: <20230526204956.4cc0ddf3@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 27 May 2023 16:36:15 -0400
Message-ID: <CADvbK_eoJUrDFrW_Kons7RnU5qivdA9ezULcMacB-H+QcNNNCQ@mail.gmail.com>
Subject: Re: [PATCH net 1/3] rtnetlink: move validate_linkmsg into rtnl_create_link
To: Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Thomas Graf <tgraf@infradead.org>, Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 11:49=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Thu, 25 May 2023 17:49:15 -0400 Xin Long wrote:
> > In commit 644c7eebbfd5 ("rtnetlink: validate attributes in do_setlink()=
"),
> > it moved validate_linkmsg() from rtnl_setlink() to do_setlink(). Howeve=
r,
> > as validate_linkmsg() is also called in __rtnl_newlink(), it caused
> > validate_linkmsg() being called twice when running 'ip link set'.
> >
> > The validate_linkmsg() was introduced by commit 1840bb13c22f5b ("[RTNL]=
:
> > Validate hardware and broadcast address attribute for RTM_NEWLINK") for
> > existing links. After adding it in do_setlink(), there's no need to cal=
l
> > it in __rtnl_newlink().
> >
> > Instead of deleting it from __rtnl_newlink(), this patch moves it to
> > rtnl_create_link() to fix the missing validation for the new created
> > links.
> >
> > Fixes: 644c7eebbfd5 ("rtnetlink: validate attributes in do_setlink()")
>
> I don't see any bug in here, is there one? Or you're just trying
> to avoid calling validation twice? I think it's better to validate
> twice than validate after some changes have already been applied
> by __rtnl_newlink()...  If we really care about the double validation
> we should pull the validation out of do_setlink(), IMHO.
Other than avoiding calling validation twice, adding validate_linkmsg() in
rtnl_create_link() also fixes the missing validation for newly created link=
s,
it includes tb[IFLA_ADDRESS/IFLA_BROADCAST] checks in validate_linkmsg():

For example, because of validate_linkmsg(), these command will fail
# ip link add dummy0 type dummy
# ip link add link dummy0 name mac0 type macsec
# ip link set mac0 address 01
RTNETLINK answers: Invalid argument
(I removed the IFLA_ADDRESS  validation in iproute2 itself)

However, the below will work:
# ip link add dummy0 type dummy
# ip link add link dummy0 name mac0 address 01 type macsec

As for the calling twice thing, validating before any changes happen
makes sense.
Based on the change in this patch, I will pull the validation out of
do_setlink()
to these 3 places:

@@ -3600,7 +3605,9 @@ static int __rtnl_newlink(struct sk_buff *skb,
struct nlmsghdr *nlh,
                        return -EEXIST;
                if (nlh->nlmsg_flags & NLM_F_REPLACE)
                        return -EOPNOTSUPP;
-
+               err =3D validate_linkmsg(dev, tb, extack);
+               if (err < 0)
+                       return err;

@@ -3377,6 +3383,9 @@ static int rtnl_group_changelink(const struct
sk_buff *skb,

        for_each_netdev_safe(net, dev, aux) {
                if (dev->group =3D=3D group) {
+                       err =3D validate_linkmsg(dev, tb, extack);
+                       if (err < 0)
+                               return err;
                        err =3D do_setlink(skb, dev, ifm, extack, tb, 0);

@@ -3140,6 +3136,10 @@ static int rtnl_setlink(struct sk_buff *skb,
struct nlmsghdr *nlh,
                goto errout;
        }

+       err =3D validate_linkmsg(dev, tb, extack);
+       if (err < 0)
+               goto errout;
+
        err =3D do_setlink(skb, dev, ifm, extack, tb, 0);


and yes, one more place calls validate_linkmsg (comparing to the old code
with the one in rtnl_create_link), unless someone thinks it's not worth it.

Thanks.

