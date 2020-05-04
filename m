Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E191C3ECD
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 17:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgEDPmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 11:42:16 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53677 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgEDPmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 11:42:15 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MgeXk-1ivSSv3BMq-00h9nG; Mon, 04 May 2020 17:42:13 +0200
Received: by mail-qt1-f172.google.com with SMTP id z90so14303905qtd.10;
        Mon, 04 May 2020 08:42:13 -0700 (PDT)
X-Gm-Message-State: AGi0PuaaWWxssFauRiT5vxTRmiQEWx5SNzQaep2fGWHmqDtbvfvVW+hj
        Kp+ULHulI5Jy/Gdw82CPn/ht+S/LCWl+QkSsurA=
X-Google-Smtp-Source: APiQypI1wW68AAiQtV/u8CtVGxCGu13k156dVbDOxMVGxqcKyvHNC4safJFvRviHzGcldu8zCdCyedYfVHFYxv8t9bk=
X-Received: by 2002:ac8:4c8d:: with SMTP id j13mr17468203qtv.142.1588606932443;
 Mon, 04 May 2020 08:42:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200428212357.2708786-1-arnd@arndb.de> <20200430052157.GD432386@unreal>
 <CAK8P3a25MeyBgwZ9ZF2JbfpVChQuZ1wWc6VT1MFZ8-7haubVDw@mail.gmail.com> <20200503053005.GC111287@unreal>
In-Reply-To: <20200503053005.GC111287@unreal>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 4 May 2020 17:41:56 +0200
X-Gmail-Original-Message-ID: <CAK8P3a30Qe=_L0Ji9k14SwGEZAKUX5FJ5YsFACGz_X3oBSSNQQ@mail.gmail.com>
Message-ID: <CAK8P3a30Qe=_L0Ji9k14SwGEZAKUX5FJ5YsFACGz_X3oBSSNQQ@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5: reduce stack usage in qp_read_field
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:1EfRFZ0AUdBWqHb05cw7NIXrhfj4pnvn+7QqkC7aTk0ycQ2i4+9
 3gfJuCcaAJtJWrngwf8R+W/Me7OqHKn6IEHqs93xwIzAfxctzt+tX3T3A9kNLWV9XGxdgio
 jUY4liwImmTg78mM1/aiIIfWAqMguP6LVGFmP215SXXRAIZK9aDUmWO4yNCK4D0c5R49yX+
 Fy1xrACU2dDbuHv0uKVmg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Nfz2EkNZeL4=:gC56rRhx++o6XPoYL60nCF
 CzGL2e6rg//IV5g4ZM0NdzOzI/hX+RDgJs3dLdIELuqob8D90wP0wUN6yvRooLfLAUdUcbS1l
 6KTStm7TGIXPPBeqCtcV9/5f18m+qiS2rfZfXzgnP/tFsCYgx9wAi+z3QZJoE+Hp6q6MqU5YZ
 mOkPq13VMPseX0G9CUqFQvn7FW8oX6SvAJ3NR4EuMOfZXdmzjUTYs8xFh7my0gv5FmWVqTI79
 OKB6BQvySrwU47x4Fb2gwI54alYlaLiBrkn8elp8uTP7S6Hbz4F5jpfQeQek6++Js93u2+jBp
 SbqzojuGMgnDlqGL7hvYh45FpFL/0oXuS5ym1LJtHATtiraRweaxX+sW+3O1owzKkAWpIE3Hr
 Sr4q3nncbd4BzH4bX07vBxdC5QGbGaKTB4tDdx47CsVRMCmjxx+B7Ug8cm4hX4HVeugXKhQ8N
 5zcHD2s3bR+rTU57rqwUeK04zYrYfomNE+ocLNtOwtj9fR7uOlixHVJ9oSMy/mge5VXtQFJTg
 tMQxlGhAqAgARovBF7ftjViIMzfVtCNPyKQB23u0IehHvFXRHpvsfCT5hTogDFr2ceJEMjHuy
 jHIJ/Y+LKxDBW6e8BD1GlCCDxZAl0caIHKsstO2TLxrqnouYM6MNFNIPPmvhrD5Gu+3g9FUsZ
 XK2dI79yaSymplwdUyaRXC04GKHBhRimY529vzajZY2mSBkhBegNr+D30D2jKovxKQS2JDAQp
 BncKXhAkl0okjrnHjY7tDtQ2+ed8s/1aA9dofG0W4cEPwii5HSrL/KD3gtbdl4W2GR2R3Gt77
 R323NwEgM548FdAKgbl5l/DncWg7nViYhNia08HBGFn8ynWesc=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 7:30 AM Leon Romanovsky <leon@kernel.org> wrote:
> On Thu, Apr 30, 2020 at 04:37:14PM +0200, Arnd Bergmann wrote:
> > On Thu, Apr 30, 2020 at 7:22 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > While warning limit is generally 1024 bytes for 32-bit architectures,
> > and 2048 bytes fro 64-bit architectures,  we should probably
> > reduce the latter to something like 1280 bytes and fix up the
> > warnings that introduces.
>
> It a chicken and an egg problem, I tried to use default frame size, but
> the output of my kernel build was constantly flooded with those warnings
> and made hard to spot real issues in the code I developed.
>

When did you last try? I usually send patches whenever I see a new
warning, so there really shouldn't be any such warnings in the mainline
kernel except for cases where patches are still under discussion.

If you have a configuration in which you see lots of frame size warnings,
can you send me that .config file for that? It is possible that one or
more of the patches in my backlog fix a bunch of those issues
and need to be resent.

      Arnd
