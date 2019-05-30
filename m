Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85AF830316
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfE3T7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:59:39 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43381 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3T7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:59:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id w33so10780912edb.10
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 12:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y+5+TJB0xxVtsaantpVQ2fx+XW3ed0kSef8guxzf4+c=;
        b=FN1Zr3yFt3vHm7AH2pjUO4ZlbTZ5+TnWlh1P683XtZ1mKoTx6EjGOt0Ea2diGPLLjh
         YNe2FXJkmxSh+0tGIZM9ri+fMceU87FwVGw6vVzb0wZDTGggGw7k865SON/l//nwybEp
         hBXSf60byPVKgqs1AZtVQNOGJgwO/6MHByxEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y+5+TJB0xxVtsaantpVQ2fx+XW3ed0kSef8guxzf4+c=;
        b=Jfo/l1sGhx5vSkAUb/1ae6ozXIkaV6b7tfcA+QGbbfZXhqvEENdWoU4/mdwCZbP9ey
         ZPZwhZrcFhRCKC1goWe95xC1Y0Yjj9sFmNkl4m/rKEQkZkzepfvbiO38g1YBMZg6lubG
         PEFiucY/9bA5rBeivolGCjykRlYExY1lTCEChEinTnBxnKhBWC7b3KrpB117Hkmh6Pqz
         +K9CzpPF1dbM3rHg6veF71pT1GYeoaunu+lfLRTu6l4KPf9CRCFJczC1BGLPRb6buaVr
         yPI4r/3JOt0Ur1pBxhF8p9IX4Trxh6Dyqifk213wS97EP308pS/rQGcz5B4Jdcyv/PF5
         89Uw==
X-Gm-Message-State: APjAAAVLqSJ02W16nocw3/3+b6sULBAq0QSjYeGnT2m/OXCYHQusrS4X
        1i00OdVosWYzSQ0iOSmHvLlXPSc3qD9iDDWfOVWfzg==
X-Google-Smtp-Source: APXvYqxvuXY8PXQIGpyREQO16IiVji264CEyM21BAv+58B7Vv6WuQS46qcmRs5RRekPhMlPRZjenfOzyJGvJh7eHzJw=
X-Received: by 2002:a50:a886:: with SMTP id k6mr6811276edc.211.1559246377806;
 Thu, 30 May 2019 12:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190530031746.2040-1-dsahern@kernel.org> <20190530031746.2040-9-dsahern@kernel.org>
In-Reply-To: <20190530031746.2040-9-dsahern@kernel.org>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Thu, 30 May 2019 12:59:26 -0700
Message-ID: <CAJieiUgpwBE8itHDuDactyjApEXqGjQWo=F=WmP-QJzTayXihA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 8/9] ip route: Add option to use nexthop objects
To:     David Ahern <dsahern@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 9:04 PM David Ahern <dsahern@kernel.org> wrote:
>
> From: David Ahern <dsahern@gmail.com>
>
> Add nhid option for routes to use nexthop objects by id.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---

man page needs an update ? :)


>  ip/iproute.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/ip/iproute.c b/ip/iproute.c
> index c5a473704d95..68f7f75f2336 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -80,7 +80,7 @@ static void usage(void)
>                 "             [ table TABLE_ID ] [ proto RTPROTO ]\n"
>                 "             [ scope SCOPE ] [ metric METRIC ]\n"
>                 "             [ ttl-propagate { enabled | disabled } ]\n"
> -               "INFO_SPEC := NH OPTIONS FLAGS [ nexthop NH ]...\n"
> +               "INFO_SPEC := { NH | nhid ID } OPTIONS FLAGS [ nexthop NH ]...\n"
>                 "NH := [ encap ENCAPTYPE ENCAPHDR ] [ via [ FAMILY ] ADDRESS ]\n"
>                 "           [ dev STRING ] [ weight NUMBER ] NHFLAGS\n"
>                 "FAMILY := [ inet | inet6 | mpls | bridge | link ]\n"
> @@ -809,6 +809,10 @@ int print_route(struct nlmsghdr *n, void *arg)
>                 print_string(PRINT_ANY, "src", "from %s ", b1);
>         }
>
> +       if (tb[RTA_NH_ID])
> +               print_uint(PRINT_ANY, "nhid", "nhid %u ",
> +                          rta_getattr_u32(tb[RTA_NH_ID]));
> +
>         if (tb[RTA_NEWDST])
>                 print_rta_newdst(fp, r, tb[RTA_NEWDST]);
>
> @@ -1080,6 +1084,7 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
>         int table_ok = 0;
>         int raw = 0;
>         int type_ok = 0;
> +       __u32 nhid = 0;
>
>         if (cmd != RTM_DELROUTE) {
>                 req.r.rtm_protocol = RTPROT_BOOT;
> @@ -1358,6 +1363,11 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
>                 } else if (strcmp(*argv, "nexthop") == 0) {
>                         nhs_ok = 1;
>                         break;
> +               } else if (!strcmp(*argv, "nhid")) {
> +                       NEXT_ARG();
> +                       if (get_u32(&nhid, *argv, 0))
> +                               invarg("\"id\" value is invalid\n", *argv);
> +                       addattr32(&req.n, sizeof(req), RTA_NH_ID, nhid);
>                 } else if (matches(*argv, "protocol") == 0) {
>                         __u32 prot;
>
> @@ -1520,7 +1530,7 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
>                          req.r.rtm_type == RTN_UNSPEC) {
>                         if (cmd == RTM_DELROUTE)
>                                 req.r.rtm_scope = RT_SCOPE_NOWHERE;
> -                       else if (!gw_ok && !nhs_ok)
> +                       else if (!gw_ok && !nhs_ok && !nhid)
>                                 req.r.rtm_scope = RT_SCOPE_LINK;
>                 }
>         }
> --
> 2.11.0
>
