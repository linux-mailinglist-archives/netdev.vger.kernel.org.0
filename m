Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3BB29F8F3
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgJ2XQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgJ2XQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 19:16:50 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58365C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 16:16:49 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id j18so3682380pfa.0
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 16:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y4XVzL/mmSoU8j74JndFP01bXPmG6zoNfcHODiIWjpQ=;
        b=jmhdwsYe6+4nWNqUbSeuSAa92KfaW2mnt5m+f4xIWeBrhLsJMpWfDXIRISXM81cRlg
         v/IaBV/+safgOk1M55ETLBqMQYhbxg2ogeimXHuVn0/duH/Pa6k6qLIlcg6lWEONOS4+
         a1Er5yPbvSfOeoKRiAa3bbV4dyEB5TER6BWdIP66ZPZS0jyj4OhGWuZUsIWnwWpME9Fc
         uDxajg18v0Rg+ZCXGIA3SYj6flAGKXWKmUQpS8x/D6QmUk/VUoy8O6eoetZrTkT1FSaO
         sttXQ3+hy/sPB2AgdCl/3kBJqrtso6Eio0pT9xKGmtrhJxYGMLMCv2JZE5HjqvPfa4aC
         qILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y4XVzL/mmSoU8j74JndFP01bXPmG6zoNfcHODiIWjpQ=;
        b=IeewqvT+K/HB4CpxbMynhJFNshc+32DMYi9g32KGnIRsghBrzgYgLa5PAQWbIVVrqu
         qO/Z0Xw9UNZdiX5rNAOW0UQ3A7KpffESyCaGhyIMl/a5Kd6IEm++gYNFpE+5MDAm5LcE
         SJVwpbVpkvlJwGs0cAjPB00LGSzkAuRG/8A2YDxBjQBWH2WM+SuZyoAXoCR2I0G9Z8pu
         ZYnqFILjbMo7eQ/FJkd3zP81Oogy9wCzFyZl6Kfl+ccsA4xBmcjIaMZuYizrF/DIiJqf
         75aZcNZp1IQM1e8mRYM+gMcl2mGiR7axscs8c608LzUeAlT/3DqL4EHOn4x4FHtUmrRe
         Nw/g==
X-Gm-Message-State: AOAM533ADGqwJLZiXFXKaAJtSWBQr9XXyZoT0FixnNc1+A3X3iIBwsWN
        0cdwoD3dlQPQeTX3HB9yMCZ6dg==
X-Google-Smtp-Source: ABdhPJxwHJuWcPp/9JgnmFxXMeRiLvygElZoew/VJy3heFc4kOG08fYFDZaj6Tm7ItrmLB40WlQFVg==
X-Received: by 2002:a05:6a00:134c:b029:160:c73:8462 with SMTP id k12-20020a056a00134cb02901600c738462mr6761798pfu.4.1604013408744;
        Thu, 29 Oct 2020 16:16:48 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t9sm927090pjo.4.2020.10.29.16.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 16:16:48 -0700 (PDT)
Date:   Thu, 29 Oct 2020 16:16:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Sharma, Puneet" <pusharma@akamai.com>
Cc:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2] tc: add print options to fix json output
Message-ID: <20201029161640.3a9c4da5@hermes.local>
In-Reply-To: <2B38A297-343E-4DD0-93E2-87F8B2AC1E26@akamai.com>
References: <20201028183554.18078-1-pusharma@akamai.com>
        <20201029131718.39b87b03@hermes.local>
        <2B38A297-343E-4DD0-93E2-87F8B2AC1E26@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 21:20:55 +0000
"Sharma, Puneet" <pusharma@akamai.com> wrote:

> I did provide an example to better explain what patch is doing.
>=20
> Sorry for long paste.
>=20
> So, with current implementation output of command:
> $ tc -s -d -j filter show dev <eth_name> ingress
>=20
> would contain:
> [{
>         "protocol": "ip",
>         "pref": 20000,
>         "kind": "basic",
>         "chain": 0
>     },{
>         "protocol": "ip",
>         "pref": 20000,
>         "kind": "basic",
>         "chain": 0,
>         "options": {handle 0x1
>   (
>     cmp(u8 at 9 layer 1 eq 6)
>     OR cmp(u8 at 9 layer 1 eq 17)
>   ) AND ipset(sg-test-ipv4 src)
>=20
>             "actions": [{
>                     "order": 1,
>                     "kind": "gact",
>                     "control_action": {
>                         "type": "pass"
>                     },
>                     "prob": {
>                         "random_type": "none",
>                         "control_action": {
>                             "type": "pass"
>                         },
>                         "val": 0
>                     },
>                     "index": 1,
>                     "ref": 1,
>                     "bind": 1,
>                     "installed": 2633,
>                     "last_used": 2633,
>                     "stats": {
>                         "bytes": 0,
>                         "packets": 0,
>                         "drops": 0,
>                         "overlimits": 0,
>                         "requeues": 0,
>                         "backlog": 0,
>                         "qlen": 0
>                     }
>                 }]
>         }
>     }
> ]
>=20
> Clearly this is an invalid JSON. Look at =E2=80=9Coptions"
>=20
>=20
> With patch it would look like:
> [{
>         "protocol": "ip",
>         "pref": 20000,
>         "kind": "basic",
>         "chain": 0
>     },{
>         "protocol": "ip",
>         "pref": 20000,
>         "kind": "basic",
>         "chain": 0,
>         "options": {
>             "handle": 1,
>             "ematch": "(cmp(u8 at 9 layer 1 eq 6)OR cmp(u8 at 9 layer 1 e=
q 17)) AND ipset(sg-test-ipv4 src)",
>             "actions": [{
>                     "order": 1,
>                     "kind": "gact",
>                     "control_action": {
>                         "type": "pass"
>                     },
>                     "prob": {
>                         "random_type": "none",
>                         "control_action": {
>                             "type": "pass"
>                         },
>                         "val": 0
>                     },
>                     "index": 1,
>                     "ref": 1,
>                     "bind": 1,
>                     "installed": 297829723,
>                     "last_used": 297829723,
>                     "stats": {
>                         "bytes": 0,
>                         "packets": 0,
>                         "drops": 0,
>                         "overlimits": 0,
>                         "requeues": 0,
>                         "backlog": 0,
>                         "qlen": 0
>                     }
>                 }]
>         }
>     }
> ]
>=20
> Now it=E2=80=99s handling the =E2=80=9Chandle=E2=80=9D and =E2=80=9Cematc=
h=E2=80=9D inside =E2=80=9Coptions" depending on context.
>=20
> Hope it=E2=80=99s more clear now.
>=20
> Thanks,
> ~Puneet.
>=20
> > On Oct 29, 2020, at 4:17 PM, Stephen Hemminger <stephen@networkplumber.=
org> wrote:
> >=20
> > On Wed, 28 Oct 2020 14:35:54 -0400
> > Puneet Sharma <pusharma@akamai.com> wrote:
> >  =20
> >> Currently, json for basic rules output does not produce correct json
> >> syntax. The following fixes were done to correct it for extended
> >> matches for use with "basic" filters.
> >>=20
> >> tc/f_basic.c: replace fprintf with print_uint to support json output.
> >> fixing this prints "handle" tag correctly in json output.
> >>=20
> >> tc/m_ematch.c: replace various fprintf with correct print.
> >> add new "ematch" tag for json output which represents
> >> "tc filter add ... basic match '()'" string. Added print_raw_string
> >> to print raw string instead of key value for json.
> >>=20
> >> lib/json_writer.c: add jsonw_raw_string to print raw text in json.
> >>=20
> >> lib/json_print.c: add print_color_raw_string to print string
> >> depending on context.
> >>=20
> >> example:
> >> $ tc -s -d -j filter show dev <eth_name> ingress
> >> Before:
> >> ...
> >> "options": {handle 0x2
> >>  (
> >>    cmp(u8 at 9 layer 1 eq 6)
> >>    OR cmp(u8 at 9 layer 1 eq 17)
> >>  ) AND ipset(test-ipv4 src)
> >>=20
> >>            "actions": [{
> >> ...
> >>=20
> >> After:
> >> [{
> >> ...
> >> "options": {
> >>    "handle": 1,
> >>    "ematch": "(cmp(u8 at 9 layer 1 eq 6)OR cmp(u8 at 9 layer 1 eq 17))=
 AND ipset(test-ipv4 src)",
> >> ...
> >> ]
> >>=20
> >> Signed-off-by: Puneet Sharma <pusharma@akamai.com>
> >> --- =20
> >=20
> > What is the point of introducing raw string?
> > The JSON standard says that string fields must use proper escapes.
> >=20
> > Please  don't emit invalid JSON. It will break consumption by other lib=
raries. =20
>=20


I agree that the existing output is wrong. But your patch introduces

+void jsonw_raw_string(json_writer_t *self, const char *value);

Why?

You should just use jsonw_string() which already handles things like special
characters in the string. In theory, there could be quotes or other charact=
ers
in the ematch string.
