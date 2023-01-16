Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2942B66B4F7
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 01:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjAPAgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 19:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjAPAf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 19:35:59 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE96E44B4
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 16:35:58 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-15085b8a2f7so27672223fac.2
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 16:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QJrV7Pvl8gL3UJIF+WlSKOon2y+GmAUYiUStdzoOVFM=;
        b=lkm+8xGDvkUFc2CaKJWxteCu9RRHc45A7Q2837phQjskhwRyjpiUTkiYataOS2g7VN
         QfWNGHrJNBu8knmhghq4CaHsmRpgO9GbThzH+NmYXqazv6m2+GF/8TL9W3NFmaT/SKN9
         hvM764+0Kb/aaAh2ct3PNUpGOECfHB9he5t6iQ7kUjgJN7m/3jDH6pBWClcg36TP23tJ
         18CTybt5ofEpPIyWThvBu29zvBWQJrGa4XxdgKtxbOHWdbLRNGEnjRHO8dTJ1YFqkGcn
         +Rr9JkL+X4zMXIfXFX/QAlCsk31l77zNJgRBt5/S+awiz6/UQh/k7+Ds5TiVjOV4XXr1
         646Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJrV7Pvl8gL3UJIF+WlSKOon2y+GmAUYiUStdzoOVFM=;
        b=hFnQSrzxvxHt8yi6Yncm86HEsMJskx7ZwzBqne6/rTboVYdg5plIzkyPOU5hY8Jb3v
         GBHKNIoCFa2qybzg57NM/wZrrtjtq3U7fNPjPlBU+Eq28zUMlh7ZrsNTuP5WjaK6Hz9W
         EMjrJAbRghRAoWfdKVj3WxBy63+Z8XYQuzdkNlblAyRKX9d2jsMXT2+msVicXjPbjv5S
         pnoi+Md5tFKMCZpi1af3BPYg4713gc4bWCyTBR8Y9CL1a3QO3Xc5rdt7T5HAcWJvooH0
         E1x/d6n5gfSMEF8wgH1GynRaOGC903Mlb4y75mZar1vv8nsoPeubmHJXVpf5uZ3h8Zie
         bZbQ==
X-Gm-Message-State: AFqh2krcE3t16xYLUfhrmlmPKeV0Zj0csy6h+gWwo8pFBIUU5AajP6Rv
        NSIGHmbtaQ9xYYzkXEHvx4s=
X-Google-Smtp-Source: AMrXdXtwpK5yW3IEboyG0JhlnmR/Qx/xxlsQe1aSQWh6jopOGtbfma+WPM1UyETVcXDLivgb2TzACA==
X-Received: by 2002:a05:6870:7c09:b0:15e:ec05:4cd7 with SMTP id je9-20020a0568707c0900b0015eec054cd7mr4389425oab.40.1673829358006;
        Sun, 15 Jan 2023 16:35:58 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:7576:e2e2:1dc2:f3df])
        by smtp.gmail.com with ESMTPSA id c15-20020a4ae24f000000b004f28d09a880sm4391916oot.13.2023.01.15.16.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 16:35:57 -0800 (PST)
Date:   Sun, 15 Jan 2023 16:35:56 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Alexander Potapenko <glider@google.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: fix possible use-after-free
Message-ID: <Y8Sb7LYDN/xjDBQy@pop-os.localdomain>
References: <20230113164849.4004848-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113164849.4004848-1-edumazet@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 04:48:49PM +0000, Eric Dumazet wrote:
> syzbot reported a nasty crash [1] in net_tx_action() which
> made little sense until we got a repro.
> 
> This repro installs a taprio qdisc, but providing an
> invalid TCA_RATE attribute.
> 
> qdisc_create() has to destroy the just initialized
> taprio qdisc, and taprio_destroy() is called.
> 
> However, the hrtimer used by taprio had already fired,
> therefore advance_sched() called __netif_schedule().
> 
> Then net_tx_action was trying to use a destroyed qdisc.
> 
> We can not undo the __netif_schedule(), so we must wait
> until one cpu serviced the qdisc before we can proceed.
> 

This workaround looks a bit ugly. I think we _may_ be able to make
hrtimer_start() as the last step of the initialization, IOW, move other
validations and allocations before it.

Can you share your reproducer?

Thanks,
