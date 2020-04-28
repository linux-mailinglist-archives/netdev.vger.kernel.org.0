Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3813F1BB74F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgD1HRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD1HRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:17:44 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE375C03C1AA
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 00:17:43 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id g13so23329718wrb.8
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 00:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C7ytbwQrgqPtHMZnsJk+EhZR6pnbWFqQeUqv88Le6Xc=;
        b=AYLXlv5JodT/Z8ADX/kSfoxuz8/Anecm93vrDhGORo/oBkVLYu+H+DGNXJ0rtOGjq+
         ght/gxY00CXNWTaHA+GOKuhrobG0bKHiUTOS70eB9Xodl1SyLossSPtRLURVpA+BoYgU
         31e3dZd9MM9w9XLRskKm2daNobjJ3qSxPoT1GKRsJ3VusI2f7vX4RRK3zSaPQaWe/9Gx
         ZS5NgJ1NsucEmMqY3XD1+L2EvYxKSzJ45wt0rCWQbR9TAQGKce9L4EfdXhtTx/oqIxka
         snwjJafyl5H4EBHgaEDxEwuto5to2k9yACKXIurTK8fxdQl2QuODV0A3qFOW6j28qx44
         KTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C7ytbwQrgqPtHMZnsJk+EhZR6pnbWFqQeUqv88Le6Xc=;
        b=ia6D8YOrwjchie6gg+t5hl6M8dXS3xCbYezcY3wye2OjFtrccDe17cCGqNVEDJUOZY
         nJ9dmrThVWgnMya4wsmZNZEQbv63wDsMTLsHBBHWDrsOFPxBmF04jHaeGBMqFcX/NS7x
         aeP+Eb8GA+mnm1M+CF8+H7zaq+X9bZD504DMv7Bzeww+bSv3YI4/Dy2lWzqKx+BCmTk2
         L2PHbM0M7iFNiCAfal6C60gDa5nAC9c+Q/E0C7fS0yv+c4tFQv9/DJJ0P/8UrWfirXiG
         HwfLRAjiievJ48StoiqzwBlphzZI/Fv6Ti+NR0I5/GZCrb4rZTBjfAXMK7EJoMFF620g
         UGjA==
X-Gm-Message-State: AGi0PuYF+GgEwGUA8wbs2fdC2wyViQcqZee0ylKEGYu4OyZfw3OkDRAu
        bIhiPsBCGDQh7ukLpEvzZkdnZ2Ap/pxpuZzP/pJHQbuw
X-Google-Smtp-Source: APiQypJ94q9Eb/4pQrQD1R3413GeL5KdAP9eumaKGiWgwoitwXAQ5a3bKJl3EWvxzK7R9+BgmtuHsvpEnZguuvnxyaA=
X-Received: by 2002:adf:cd0a:: with SMTP id w10mr30877972wrm.404.1588058262491;
 Tue, 28 Apr 2020 00:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1581676056.git.lucien.xin@gmail.com> <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan> <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200423082351.5cd10f4d@hermes.lan>
In-Reply-To: <20200423082351.5cd10f4d@hermes.lan>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 28 Apr 2020 15:22:59 +0800
Message-ID: <CADvbK_cOGa6ndnTL9r1Upw0pKNKnasnbKQDfoOghZih3jtX8ZQ@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 11:24 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Sat, 15 Feb 2020 01:40:27 +0800
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > On Sat, Feb 15, 2020 at 12:13 AM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> > >
> > > On Fri, 14 Feb 2020 18:30:47 +0800
> > > Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > > +
> > > > +     open_json_array(PRINT_JSON, name);
> > > > +     open_json_object(NULL);
> > > > +     print_uint(PRINT_JSON, "ver", NULL, ver);
> > > > +     print_uint(PRINT_JSON, "index", NULL, idx);
> > > > +     print_uint(PRINT_JSON, "dir", NULL, dir);
> > > > +     print_uint(PRINT_JSON, "hwid", NULL, hwid);
> > > > +     close_json_object();
> > > > +     close_json_array(PRINT_JSON, name);
> > > > +
> > > > +     print_nl();
> > > > +     print_string(PRINT_FP, name, "\t%s ", name);
> > > > +     sprintf(strbuf, "%02x:%08x:%02x:%02x", ver, idx, dir, hwid);
> > > > +     print_string(PRINT_FP, NULL, "%s ", strbuf);
> > > > +}
> > >
> > > Instead of having two sets of prints, is it possible to do this
> > >         print_nl();
> > >         print_string(PRINT_FP, NULL, "\t", NULL);
> > >
> > >         open_json_array(PRINT_ANY, name);
> > >         open_json_object(NULL);
> > >         print_0xhex(PRINT_ANY, "ver", " %02x", ver);
> > >         print_0xhex(PRINT_ANY, "idx", ":%08x", idx);
> > >         print_0xhex(PRINT_ANY, "dir", ":%02x", dir);
> > >         print_0xhex(PRINT_ANY, "hwid", ":%02x", hwid)
> > >         close_json_object();
> > >         close_json_array(PRINT_ANY, " ");
> > Hi Stephen,
> >
> > This's not gonna work. as the output will be:
> > {"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
> > instead of
> > {"ver":2,"index":0,"dir":1,"hwid":2} (number)
> >
> > >
> > > Also, you seem to not hear the request to not use opaque hex values
> > > in the iproute2 interface. The version, index, etc should be distinct
> > > parameter values not a hex string.
> > The opts STRING, especially these like "XX:YY:ZZ" are represented
> > as hex string on both adding and dumping. It is to keep consistent with
> > geneve_opts in m_tunnel_key and f_flower,  see
>
> There are several different requests.
>
>  1. The format of the output must match the input.
>  2. Printing values in hex would be nice if they are bit fields
>  3. If non json uses hex, then json should use hex
>     json is type less so { "ver":2 } and { "ver":"0x2" } are the same
>
V4 has been posted, with respect to these 3 rules.
And all numbers are in uint type, no problems about { "ver":2 } and {
"ver":"0x2" } things.

Thanks.
