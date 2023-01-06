Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B403660964
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 23:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjAFWQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 17:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjAFWQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 17:16:43 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A917CBF1
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 14:16:42 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so6660606pjj.2
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 14:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n21hAxxmDVWDGLpoMuYenY1svbThqQKC5WsR2B3FVH4=;
        b=dwSkgVGoWjNgqzQq/0Z+bjnX1CuLDD1CWoFlwGn7KXzPoSpsGUXL7uRgZPR+AWFUOA
         S60pAGgfx/Enw/eShBYtacr75QDD+EKMfrg1UneoY6N1i9BOyL4Pm9yBSahBzMjrJBEq
         M/r/80RTWl8RFLqvIH7FJYk8jQTAehnc2eTrauyEh4N9zhwjmtmdCmExYhv+cJtfg5Bk
         9Xbnuph8DG1mw2vq8xOgPMa1Ywd9r1t5k6kSd2mCGZVJ/4eHVeOLum7oJFKT8b+VFUip
         BkFDasi6Re9TrNlClC261hvBheOLrTgwBnnCJ9j/nOVDMh2obAdwCLZGUn59UwcsxHli
         y+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n21hAxxmDVWDGLpoMuYenY1svbThqQKC5WsR2B3FVH4=;
        b=urjAPKbkT42L88ALFjdiIVMwUGTeqV3KscimDtFXBjIeT4pYTkuKAQqg3gP6bWh7bN
         t40HiOjQH590jehw6Q+75FgIyb9hIbuA2hI9SnuTOkWfHbvZ3kLas0/C+Tp7QidGBHqt
         2vKxcL8+EprHfuxfXBGPEbUOPAc2EvpwtpcA+fjkMJmx0ssU86I6p6B9taPQkqXxEASc
         q+0Nxa0ck7c4IrLAsePeA/xKDDvxCUuVDO4eM0qMkBpYGKuHH4joKrARaDILZRVoGjil
         SEi5OW3kHhcvSqmvpm2poGon5kfttNw0GaTUN45kw5DlMrfFbpyoknmmmzSziiqFSolS
         BCfw==
X-Gm-Message-State: AFqh2kp6V8/3dKJWw44B8x2HO9fYM4+iV5tO6ztjtxJFgfKMKM855HTG
        Qlbx5RzlFCLQ2uKiEsQi0t7G1cADmPlm83Pz1bI=
X-Google-Smtp-Source: AMrXdXsVCR6b4j64e7k3cN/9xvHsRLikoDJwIvG4Q2sOr1rx13bKXn1OgVBUqibwmoAuab6aAuDR3qFATHNp/NIYzw4=
X-Received: by 2002:a17:902:ef43:b0:189:596c:b221 with SMTP id
 e3-20020a170902ef4300b00189596cb221mr3585150plx.76.1673043401621; Fri, 06 Jan
 2023 14:16:41 -0800 (PST)
MIME-Version: 1.0
References: <20221227173620.6577-1-glipus@gmail.com> <Y7a+dS2Ga5fdPJ1Y@corigine.com>
In-Reply-To: <Y7a+dS2Ga5fdPJ1Y@corigine.com>
From:   Max Georgiev <glipus@gmail.com>
Date:   Fri, 6 Jan 2023 15:16:30 -0700
Message-ID: <CAP5jrPGXVKsSNm=9M-7du4zB0errcmR9qHuu_GO=bvTZtccaRA@mail.gmail.com>
Subject: Re: [PATCH ethtool-next] Fixing boolean value output for Netlink
 reported values in JSON format
To:     Simon Horman <simon.horman@corigine.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 5, 2023 at 5:11 AM Simon Horman <simon.horman@corigine.com> wrote:
>
> On Tue, Dec 27, 2022 at 10:36:20AM -0700, Maxim Georgiev wrote:
> > Current implementation of show_bool_val() passes "val" parameter of pointer
> > type as a last parameter to print_bool():
> > https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/tree/netlink/netlink.h#n131
> > ...
> > static inline void show_bool_val(const char *key, const char *fmt, uint8_t *val)
> > {
> >       if (is_json_context()) {
> >               if (val)
> > >                     print_bool(PRINT_JSON, key, NULL, val);
> >       } else {
> > ...
> > print_bool() expects the last parameter to be bool:
> > https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/tree/json_print.c#n153
> > ...
> > void print_bool(enum output_type type,
> >               const char *key,
> >               const char *fmt,
> >               bool value)
> > {
> > ...
> > Current show_bool_val() implementation converts "val" pointer to bool while
> > calling show_bool_val(). As a result show_bool_val() always prints the value
> > as "true" as long as it gets a non-null pointer to the boolean value, even if
> > the referred boolean value is false.
> >
> > Fixes: 7e5c1ddbe67d ("pause: add --json support")
> > Signed-off-by: Maxim Georgiev <glipus@gmail.com>
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> I'm assuming that val is never NULL :)

Simon, thank you for taking a look!
Yes, the "if (val)" check on line 130 guarantees that "print_bool()"
on line 131 is called only if val is not null.

>
> > ---
> >  netlink/netlink.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/netlink/netlink.h b/netlink/netlink.h
> > index 3240fca..1274a3b 100644
> > --- a/netlink/netlink.h
> > +++ b/netlink/netlink.h
> > @@ -128,7 +128,7 @@ static inline void show_bool_val(const char *key, const char *fmt, uint8_t *val)
> >  {
> >       if (is_json_context()) {
> >               if (val)
> > -                     print_bool(PRINT_JSON, key, NULL, val);
> > +                     print_bool(PRINT_JSON, key, NULL, *val);
> >       } else {
> >               print_string(PRINT_FP, NULL, fmt, u8_to_bool(val));
> >       }
> > --
> > 2.38.1
> >
