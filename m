Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A9A6A2ACF
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBYQmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBYQmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:42:11 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86554199D0
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:42:00 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-536af432ee5so64831477b3.0
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u+fyK/XYD7rHV2B28/hYN8bCzWtMJEIa9GEWDvNpwJI=;
        b=mBBsLUx/HeZO4zAimQODnF69V4gC6bjcaOx7IoUcZSIUEdJ5Hk42J/vBrDQ1S8sAKe
         lxM9pIp6Ja9yuujkI8rJ2Y1dYGWUOTK4YJW14MzMPnIHz/IlUqfJ7MQ67x0g8/K5bgMr
         8MtSTGtfODoSU8Woq0EjlnLwzs2IRbSV9+7N0DkrgqQbyErv4OvNAsB1WTLaMELQ7Y0M
         j4liJTT1jecchUngJbHiXTEwHCbUx2p9B6nFUFjNFYxdljRCoAzodPB3Urx34EcTZ0HX
         gHblEDN74bE+YPqJA1h/SDaW5FUqc0hwOU3hQxXVDODiTm3VvrARkC5TJXaxlh/Xd+yB
         QRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u+fyK/XYD7rHV2B28/hYN8bCzWtMJEIa9GEWDvNpwJI=;
        b=6cKcBx6TmMlg2AlH7b/7JY1C7OHekg2syge45qf16I+h2PaIVrLo7OVL1E0Uo7JeYv
         08m7tuJbkdwiVDxB05HF8zrE4a/oY81Bt92XWclo0uzan9pjRFn1vSWO38OSUl7GKsS9
         VYG7D4lDAGV+ufEw69o1mZrEZ5dl7nANzsZd2bVXFrOKRXvJr8d4o5La2tfkEUJ4tz5g
         X0iPxjoadyRhOUipPbxtrEw1ARegksDlykrjcrI6oNizFIGfbR+TKiTfXEithPPbdVYu
         sd/4cu/ghELj3VNqqjbhujBByEZE7pSbYSYS8MfwxPlWqsF7aYw3LsIzs0PX4lhIYUJn
         IUmA==
X-Gm-Message-State: AO0yUKVxJ6qNazue32r2Xjk26llx6GJG8FEvpG9WSj3rQt4MlqBM1L6U
        By4gIUjNJC527EUSydwpIvEA6bbDRz0sVRQW4t6TsNoXFncdJw==
X-Google-Smtp-Source: AK7set9frgD8Em2wsRhhjG0USL7AMYuHhjJDHPCI5wLXjeop2zR4WgL0xO0lrklOIvRHwqurEBbcfkfi9fwRiAmaIpc=
X-Received: by 2002:a81:ad0f:0:b0:52e:cea7:f6e0 with SMTP id
 l15-20020a81ad0f000000b0052ecea7f6e0mr6795851ywh.7.1677343319723; Sat, 25 Feb
 2023 08:41:59 -0800 (PST)
MIME-Version: 1.0
References: <20230225003754.1726760-1-kuba@kernel.org>
In-Reply-To: <20230225003754.1726760-1-kuba@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sat, 25 Feb 2023 11:41:48 -0500
Message-ID: <CAM0EoMk_XOeMPXf8o165Z5UGGFHufKO4+_q8UxdVnS3z_imVpg@mail.gmail.com>
Subject: Re: [PATCH iproute2] genl: print caps for all families
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        netdev@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 7:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Back in 2006 kernel commit 334c29a64507 ("[GENETLINK]: Move
> command capabilities to flags.") removed some attributes and
> moved the capabilities to flags. Corresponding iproute2
> commit 26328fc3933f ("Add controller support for new features
> exposed") added the ability to print those caps.
>
> Printing is gated on version of the family, but we're checking
> the version of each individual family rather than the control
> family. The format of attributes in the control family
> is dictated by the version of the control family alone.
>
> In fact the entire version check is not strictly necessary.
> The code is not using the old attributes, so on older kernels
> it will simply print nothing either way.
>
> Families can't use flags for random things, because kernel core
> has a fixed interpretation.
>
> Thanks to this change caps will be shown for all families
> (assuming kernel newer than 2.6.19), not just those which
> by coincidence have their local version >= 2.
>
> For instance devlink, before:
>
>   $ genl ctrl get name devlink
>   Name: devlink
>         ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
>         commands supported:
>                 #1:  ID-0x1
>                 #2:  ID-0x5
>                 #3:  ID-0x6
>                 ...
>
> after:
>
>   $ genl ctrl get name devlink
>   Name: devlink
>         ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
>         commands supported:
>                 #1:  ID-0x1
>                 Capabilities (0xe):
>                   can doit; can dumpit; has policy
>
>                 #2:  ID-0x5
>                 Capabilities (0xe):
>                   can doit; can dumpit; has policy
>
>                 #3:  ID-0x6
>                 Capabilities (0xb):
>                   requires admin permission; can doit; has policy
>
> Fixes: 26328fc3933f ("Add controller support for new features exposed")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  genl/ctrl.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/genl/ctrl.c b/genl/ctrl.c
> index a2d87af0ad07..8d2e944802ba 100644
> --- a/genl/ctrl.c
> +++ b/genl/ctrl.c
> @@ -57,7 +57,7 @@ static void print_ctrl_cmd_flags(FILE *fp, __u32 fl)
>         fprintf(fp, "\n");
>  }
>
> -static int print_ctrl_cmds(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
> +static int print_ctrl_cmds(FILE *fp, struct rtattr *arg)
>  {
>         struct rtattr *tb[CTRL_ATTR_OP_MAX + 1];
>
> @@ -70,7 +70,7 @@ static int print_ctrl_cmds(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
>                 fprintf(fp, " ID-0x%x ",*id);
>         }
>         /* we are only gonna do this for newer version of the controller */
> -       if (tb[CTRL_ATTR_OP_FLAGS] && ctrl_ver >= 0x2) {
> +       if (tb[CTRL_ATTR_OP_FLAGS]) {
>                 __u32 *fl = RTA_DATA(tb[CTRL_ATTR_OP_FLAGS]);
>                 print_ctrl_cmd_flags(fp, *fl);
>         }
> @@ -78,7 +78,7 @@ static int print_ctrl_cmds(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
>
>  }
>
> -static int print_ctrl_grp(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
> +static int print_ctrl_grp(FILE *fp, struct rtattr *arg)
>  {
>         struct rtattr *tb[CTRL_ATTR_MCAST_GRP_MAX + 1];
>
> @@ -109,7 +109,6 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
>         int len = n->nlmsg_len;
>         struct rtattr *attrs;
>         FILE *fp = (FILE *) arg;
> -       __u32 ctrl_v = 0x1;
>
>         if (n->nlmsg_type !=  GENL_ID_CTRL) {
>                 fprintf(stderr, "Not a controller message, nlmsg_len=%d "
> @@ -148,7 +147,6 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
>         if (tb[CTRL_ATTR_VERSION]) {
>                 __u32 *v = RTA_DATA(tb[CTRL_ATTR_VERSION]);
>                 fprintf(fp, " Version: 0x%x ",*v);
> -               ctrl_v = *v;
>         }
>         if (tb[CTRL_ATTR_HDRSIZE]) {
>                 __u32 *h = RTA_DATA(tb[CTRL_ATTR_HDRSIZE]);
> @@ -198,7 +196,7 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
>                 for (i = 0; i < GENL_MAX_FAM_OPS; i++) {
>                         if (tb2[i]) {
>                                 fprintf(fp, "\t\t#%d: ", i);
> -                               if (0 > print_ctrl_cmds(fp, tb2[i], ctrl_v)) {
> +                               if (0 > print_ctrl_cmds(fp, tb2[i])) {
>                                         fprintf(fp, "Error printing command\n");
>                                 }
>                                 /* for next command */
> @@ -221,7 +219,7 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
>                 for (i = 0; i < GENL_MAX_FAM_GRPS; i++) {
>                         if (tb2[i]) {
>                                 fprintf(fp, "\t\t#%d: ", i);
> -                               if (0 > print_ctrl_grp(fp, tb2[i], ctrl_v))
> +                               if (0 > print_ctrl_grp(fp, tb2[i]))
>                                         fprintf(fp, "Error printing group\n");
>                                 /* for next group */
>                                 fprintf(fp,"\n");
> --
> 2.39.2
>

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
