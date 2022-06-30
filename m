Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289115621E7
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiF3SSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiF3SSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:18:42 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9C741638;
        Thu, 30 Jun 2022 11:18:41 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id i1so24001714wrb.11;
        Thu, 30 Jun 2022 11:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IlWda/HqLDW0Gj9EzBCbVVvBNMNupFxIokvORQdSsqo=;
        b=V/zbNJ6cE8PQmwOmoJpRuC574tlVTyOl3bRzQSGcqGDXct0qNy8MUEeBECXhj/izKq
         UiVXAKMnTGkdjCUTIycQfaT4doug4CMxnqNEoxZSDoRsJGp0QgzInqRw88lm11V4Tn5c
         nt/ho05icwky/AApXOKb5fuh/eDQo5Byho5ynpwCofAWcCrXg1km3LKX5FDh9fmgfIN7
         9QmqnDnskFHha6ziAQtYGUiC7vrbTIOD0lIa3WA02vfli5feqRTEx5f+wohvzfl04HZp
         BeULzibZbiN+ByeEVVZBmI+R0z8W+ZXNJ3QSwOK+KttculFfTLMBIl8A4SGiwLHBjz4J
         MTHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IlWda/HqLDW0Gj9EzBCbVVvBNMNupFxIokvORQdSsqo=;
        b=G8YHqaVmYK5v6JBja2NVR5orVF4rIURfxY93muzAQ9Rnn9hSxnqbei3JFt3n0XlYld
         FgR8n9zpvq5f9+JUUCV3gHh/Sb4Ma0D2Ec10fTte4G+l2xM9SIOo31gAb9w8xJglpmXp
         ophXmgzo9luYxk94JF8Q5VqrzVgVhRpoeGORl1DlwdpM2SXmC4RGsJ2ks8Ck/uJYlQO6
         NpZDV3XE10q/wkLU6KNTSivCUnyjQotUtRQ6+piXJrN9RqDt0MYgyAiDHmzxB2OL0S+b
         VWzyNbwY1dh3d+12oxthn90DPSHbEOzWkw0h4H5Wd89WTuJGsLmhwQEivAq2KbD6UHDt
         2rIg==
X-Gm-Message-State: AJIora9I/E6hBL0Zb+KQUSP5iXhrAHb0ubs98pnr1Ts2UQy9/ODDIuHZ
        QKHw2i/JvIHUYfRbPsdZDeQXFFlYa0Qn+w==
X-Google-Smtp-Source: AGRyM1vREQxVFqTQbWuZ+WMeoR0noQOq0lb5dZV2MaVEVJr5GIj324clqAcL9faYncg9EBN8e8VzLA==
X-Received: by 2002:adf:dc91:0:b0:21b:89bc:9d5c with SMTP id r17-20020adfdc91000000b0021b89bc9d5cmr9822813wrj.159.1656613120062;
        Thu, 30 Jun 2022 11:18:40 -0700 (PDT)
Received: from opensuse.localnet (host-87-6-98-182.retail.telecomitalia.it. [87.6.98.182])
        by smtp.gmail.com with ESMTPSA id l34-20020a05600c1d2200b003a03e63e428sm4648060wms.36.2022.06.30.11.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 11:18:38 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
Date:   Thu, 30 Jun 2022 20:18:36 +0200
Message-ID: <2254584.ElGaqSPkdT@opensuse>
In-Reply-To: <CAKgT0UcKRJUJrpFHdNrdH98eu_dpiZiVakJRqc2qHrdGJJQRQA@mail.gmail.com>
References: <20220629085836.18042-1-fmdefrancesco@gmail.com> <CANn89iK6g+4Fy2VMV7=feUAOUDHu-J38be+oU76yp+zGH6xCJQ@mail.gmail.com> <CAKgT0UcKRJUJrpFHdNrdH98eu_dpiZiVakJRqc2qHrdGJJQRQA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On gioved=C3=AC 30 giugno 2022 18:09:18 CEST Alexander Duyck wrote:
> On Thu, Jun 30, 2022 at 8:25 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Jun 30, 2022 at 5:17 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Thu, Jun 30, 2022 at 3:10 AM Maciej Fijalkowski
> > > <maciej.fijalkowski@intel.com> wrote:
> > > >
> > > > On Wed, Jun 29, 2022 at 10:58:36AM +0200, Fabio M. De Francesco=20
wrote:
> > > > > The use of kmap() is being deprecated in favor of=20
kmap_local_page().
> > > > >
> > > > > With kmap_local_page(), the mapping is per thread, CPU local and=
=20
not
> > > > > globally visible. Furthermore, the mapping can be acquired from=20
any context
> > > > > (including interrupts).
> > > > >
> > > > > Therefore, use kmap_local_page() in ixgbe_check_lbtest_frame()=20
because
> > > > > this mapping is per thread, CPU local, and not globally visible.
> > > >
> > > > Hi,
> > > >
> > > > I'd like to ask why kmap was there in the first place and not plain
> > > > page_address() ?
> > > >
> > > > Alex?
> > >
> > > The page_address function only works on architectures that have=20
access
> > > to all of physical memory via virtual memory addresses. The kmap
> > > function is meant to take care of highmem which will need to be=20
mapped
> > > before it can be accessed.
> > >
> > > For non-highmem pages kmap just calls the page_address function.
> > > https://elixir.bootlin.com/linux/latest/source/include/linux/highmem-=
internal.h#L40
> >
> >
> > Sure, but drivers/net/ethernet/intel/ixgbe/ixgbe_main.c is allocating
> > pages that are not highmem ?
> >
> > This kmap() does not seem needed.
>=20
> Good point. So odds are page_address is fine to use. Actually there is
> a note to that effect in ixgbe_pull_tail.
>=20
> As such we could probably go through and update igb, and several of
> the other Intel drivers as well.
>=20
> - Alex
>=20
I don't know this code, however I know kmap*().

I assumed that, if author used kmap(), there was possibility that the page=
=20
came from highmem.

In that case kmap_local_page() looks correct here.

However, now I read that that page _cannot_ come from highmem. Therefore,=20
page_address() would suffice.

If you all want I can replace kmap() / kunmap() with a "plain"=20
page_address(). Please let me know.

Thanks,

=46abio



