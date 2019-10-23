Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC7FE115D
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 07:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732108AbfJWFAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 01:00:06 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35733 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730470AbfJWFAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 01:00:06 -0400
Received: by mail-io1-f66.google.com with SMTP id t18so19206695iog.2
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 22:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VOs/1bW3/hef6rSZ4MH1J35a8U8nkcy3k1uj8GW5HnU=;
        b=oIBPo5OgIAB70zgFLIPDZJ8O2dmP6XAn4NQ7dm8w5bhc2HF+AkU4RZCH/tPQB/MSg1
         2MUNeiNVM2VDb67PUN0LGD42IG5rPfEpIuCUV2PEADExd7SGupm2+UoeEOsexIfDNqIe
         md8v768dQNSJ0M/zk8IcSzQFeJ56Dr9taiaGOrayCfjNDznhBtLyDSK5YzRtABFR/pRy
         bJqL93y1zLAHfUoXEKOPjperUyM7XCgOHqt620QpTak6i97FTfss9izf+SJ0mS6+dcyY
         2q7PFFNRVLabwCWjhnDY5wy243/3J3xhMfyI9y5Jsa/wHBMm4i96bV3fJ4FUUTXRiYTt
         pTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VOs/1bW3/hef6rSZ4MH1J35a8U8nkcy3k1uj8GW5HnU=;
        b=qf/6Uph6u7Ecsv4AhCVZrlFb9iLm6XjpEpg4IcQsQYB+Xsxf9dozhoiBjaJ2R4maOX
         Uuw3NcWZw+4g2yB6mwQ/6jMKOVPuz7cTIKHbz6bkLMfJXdJ4DBc77HLWYodHqnpJdklp
         zWjUSrtYBUkeh/Zk+lITVqkL6HL4GuW673sqvJ5xKp+Hv8CDwfVX+IxARLYIlWXX0let
         696L5Jc5iWFBRn35cVVOQczgBOe4QdkHtR6ZFT2dMxx4+lFXQ9swk+Tmu9uMNfqKu6PB
         V4NFx8O+PHSZIb5dVTIW5/Qzu2xaCGOpem9rZjuXOHnVsCK7dPUVFnRq11Uuya9zRMYU
         gfnA==
X-Gm-Message-State: APjAAAXRIolGK6lAG5TFgKhk+/Dbs4/VMT3W1nTGHNm717RJH/qJToZT
        7oZfKKuYNk7l4AgyPdZM2KInKt/6KxsnGQUAVZrOPg==
X-Google-Smtp-Source: APXvYqxVRAIaw+yTg+PoHhQFzWb6GbWm2sBTxug/S454feFKxxn9IOsiIqoBg7C9em0aaXXDHw6AR5PAXwXoAxYEF4Q=
X-Received: by 2002:a6b:b458:: with SMTP id d85mr1400928iof.287.1571806804721;
 Tue, 22 Oct 2019 22:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <1525199561-9302-1-git-send-email-dave.taht@gmail.com> <20191021164756.33d97954@hermes.lan>
In-Reply-To: <20191021164756.33d97954@hermes.lan>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 22 Oct 2019 21:59:53 -0700
Message-ID: <CAA93jw7hK0mxkhPNr0gL4k1Q2STuF88XRMtyXUksrOb3P1rLPg@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] Add tc-BPF example for a TCP pure ack recognizer
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 4:48 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue,  1 May 2018 11:32:41 -0700
> Dave Taht <dave.taht@gmail.com> wrote:
>
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright 2017 Google Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> > + * 02110-1301, USA.
> > + */
> > +
>
> SPDX is enough don't add boilerplate.

I had posted this example code 2+ years ago, and, um, this was rather
a long time to await code review.

Do y'all actually want this?

--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
