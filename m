Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3199C595198
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 07:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbiHPFD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 01:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiHPFDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 01:03:09 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED171B9DC3;
        Mon, 15 Aug 2022 14:04:41 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id DB9963200495;
        Mon, 15 Aug 2022 17:04:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 15 Aug 2022 17:04:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660597479; x=1660683879; bh=/DXZeTr6nc
        QrsVrzKQetD1MJlZAdV7mdoExoKtlNx08=; b=vaek1/hY6jpMZLhoeTR3/5UZGn
        zzeKgLdOTEUFTA2ZKYJm0CXjiH0C35BCGPXaa0M5T0htHV3tfujr6O4OAO3H8LIs
        WJnb/ZCfJzdxDwUPR0wY9PXRTdrfV+IYDknLKdXlRSKfIG7/wZxl9gkOB/EgSFTw
        CmI5V7TdaIwknwIZ7v3nokqWaFzs0tGu/VaGYF4+VXITKCQtOrc20Ur6yHhdv/ZY
        R/9yqTwhWKll8LS+bg7HR3VP9sdTUSqdV89AoDx1min8ZYwqhGMeAqI3Sb/X0eYR
        62CzpMExjDWxY9skYjC28GdkR5WACbCjkrDbNbNd9FxN2mYD4duriuE7mtYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660597479; x=1660683879; bh=/DXZeTr6ncQrsVrzKQetD1MJlZAd
        V7mdoExoKtlNx08=; b=Bp6uuZFQrhSxxp2kYUkxaPwvE1Wxr5YX4K/JLV68NDXQ
        y96rQ30LHsxprGpTyEvcEP7rdCspX2pteIlROU8AOwy0tnjKQn0IHDmHWvJJizSk
        tL0ccd22ipDSGJDNmwHdw98cr+sqzil8cYSWVtt78NHZLl/WPSCK1fLYULx+Fi4y
        1HpFvcbnoUpgNWQIomq7KLm7waSmpEnOFeKSynIgus8TiUkGnA6HCZZt82y8zLqb
        kKm6XwVBDSBi08XaBntHgWtRCKsn+Wy/GxYkKu9e64nA5WPncuD0xlPjksSH5Lvg
        MKPalEY2I5JNMMqqflw6hDEZFTCPw/MMR1dBaV8o3w==
X-ME-Sender: <xms:5rT6YuCj6Ap-BrzZKaz7yljDDykoyKKfO6IFFYqmem14XBBK5trBkQ>
    <xme:5rT6Yogiv0LW8EXzojDRowWeSxJpDtW5J1CXmmg_Fwyi9ai0DBHr1vw6ULf0EvNP4
    AW6V7kfy3ZENiJwdw>
X-ME-Received: <xmr:5rT6Yhk8KOEu8nlXi0-t3wzecwrGNm2Vnjagmxo8OMGubVH3IspxtmUxOqCOaxM1wL3DyW0L6A76VTxiKfczok4YBBw0WrKT1j9YXvBXsCcOJtjvdaVhqesf5X11>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudehkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgu
    rhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtf
    frrghtthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteev
    udeitedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:5rT6Ysx4D16efdLye-L_68Q379-Hxdqbl84wWtYmRmovQ3DNph3hxQ>
    <xmx:5rT6YjR7cXMdgIuEhUw9p0fZ743IvHNO738KJGfL1bW7SWbkRqtBOA>
    <xmx:5rT6YnbJ2EiLxrzs3QHfNcYdoMEzppM8qb7ISQZuuVimW-Za18fF_g>
    <xmx:57T6Ykj_r77gCL1HrNQKD70JFChemj-1IpjT7KG9TaKEHSjrJCXicQ>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 17:04:37 -0400 (EDT)
Date:   Mon, 15 Aug 2022 14:04:37 -0700
From:   Andres Freund <andres@anarazel.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        c@redhat.com
Subject: Re: upstream kernel crashes
Message-ID: <20220815210437.saptyw6clr7datun@awork3.anarazel.de>
References: <20220815034532-mutt-send-email-mst@kernel.org>
 <20220815081527.soikyi365azh5qpu@awork3.anarazel.de>
 <20220815042623-mutt-send-email-mst@kernel.org>
 <FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE@anarazel.de>
 <20220815113729-mutt-send-email-mst@kernel.org>
 <20220815164503.jsoezxcm6q4u2b6j@awork3.anarazel.de>
 <20220815124748-mutt-send-email-mst@kernel.org>
 <20220815174617.z4chnftzcbv6frqr@awork3.anarazel.de>
 <20220815161423-mutt-send-email-mst@kernel.org>
 <20220815205330.m54g7vcs77r6owd6@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815205330.m54g7vcs77r6owd6@awork3.anarazel.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-15 13:53:31 -0700, Andres Freund wrote:
> The reason the debug patch didn't change anything, and that my debug printk
> didn't show, is that gcp uses the legacy paths...
> 
> If there were a bug in the legacy path, it'd explain why the problem only
> shows on gcp, and not in other situations.
> 
> I'll queue testing the legacy path with the equivalent change.

Booting with the equivalent change, atop 5.19, in the legacy setup_vq()
reliably causes boot to hang:

[    0.718768] ACPI: button: Sleep Button [SLPF]
[    0.721989] ACPI: \_SB_.LNKC: Enabled at IRQ 11
[    0.722688] adebug: use legacy: 0
[    0.722724] virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
[    0.724286] adebug: probe modern: -19
[    0.727353] ACPI: \_SB_.LNKD: Enabled at IRQ 10
[    0.728719] adebug: use legacy: 0
[    0.728766] virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
[    0.730422] adebug: probe modern: -19
[    0.733552] ACPI: \_SB_.LNKA: Enabled at IRQ 10
[    0.734923] adebug: use legacy: 0
[    0.734957] virtio-pci 0000:00:05.0: virtio_pci: leaving for legacy driver
[    0.736426] adebug: probe modern: -19
[    0.739039] ACPI: \_SB_.LNKB: Enabled at IRQ 11
[    0.740350] adebug: use legacy: 0
[    0.740390] virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
[    0.742142] adebug: probe modern: -19
[    0.747627] adebug: legacy setup_vq
[    0.748243] virtio-pci 0000:00:05.0: adebug: legacy: not limiting queue size, only 256
[    0.751081] adebug: legacy setup_vq
[    0.751110] virtio-pci 0000:00:05.0: adebug: legacy: not limiting queue size, only 256
[    0.754028] adebug: legacy setup_vq
[    0.754059] virtio-pci 0000:00:05.0: adebug: legacy: not limiting queue size, only 1
[    0.757760] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.759135] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.760399] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    0.761610] 00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
[    0.762923] 00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
[    0.764222] Non-volatile memory driver v1.3
[    0.768857] adebug: legacy setup_vq
[    0.768882] virtio-pci 0000:00:06.0: adebug: legacy: not limiting queue size, only 256
[    0.773002] Linux agpgart interface v0.103
[    0.775424] loop: module loaded
[    0.780513] adebug: legacy setup_vq
[    0.780538] virtio-pci 0000:00:03.0: adebug: legacy: limiting queue size from 8192 to 1024
[    0.784075] adebug: legacy setup_vq
[    0.784104] virtio-pci 0000:00:03.0: adebug: legacy: limiting queue size from 8192 to 1024
[    0.787073] adebug: legacy setup_vq
[    0.787101] virtio-pci 0000:00:03.0: adebug: legacy: limiting queue size from 8192 to 1024
[    0.790379] scsi host0: Virtio SCSI HBA
[    0.795968] Freeing initrd memory: 7236K

Greetings,

Andres Freund
