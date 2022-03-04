Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DEE4CD4F9
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiCDNRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiCDNRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:17:32 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1D91B50DD
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 05:16:45 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id w3-20020a056830060300b005ad10e3becaso7396088oti.3
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 05:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c9/jSKEYWvjLYNnnhLPXkny4KyJtY1E3bTqXKWbpe38=;
        b=Jtoc93twUP7xt3r79Uyv6rhXGAGErLwtgbpDV0TdhEQLZukQFNjpRDFDC/bJ3XS64t
         Qya/0WpS5ZGuoPxfr6xXDfYrQK4PkM6ukAxxg/9Hb0JnTX+wmPVE+D/XqOTL2GrmI6qe
         LO4Qgwe3oa4I9Wr5CYJ7nf+FNizvb0WCsCQOLQ2pnOOpe57bQ/ck3w8uTo6LlxdAAMrf
         9cDNTJb7heD08la654ZqIdA3m4wqVwkE2TfSzZk0hdWrqIGtsB3Qm5AvHAHSh9xUX+5y
         48zipgUTasJF4JXa9uW/2YjQgag6duDl3fn4LeEN8AOrirH0Peq/Nq+1t6ltkdRAlJYM
         nV+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c9/jSKEYWvjLYNnnhLPXkny4KyJtY1E3bTqXKWbpe38=;
        b=Irukw46a87009xCvOBQKUNNYZO8OXejOc6Vujag4SlCSujG4K+S5ANveey2OXCaov2
         m939krAwb99lavWRD6T3mffqBzQ0GomLeVwEb7F98yXWu/39/hBHU2W4e9DSqusTpkQv
         HPdutm2d5mQA+2QjI8HlXSrH0aLRonHcKOd3DSpQgxF8vHiB9a/uB7ob5cHUd8eVyiYR
         nZF8OdyytASPpP2v7Mnji/1S7P65OxE9nchLC/GPR3mtbUhQR9m2L7RfdL5kb4W6seVu
         lTtyXSwRzt+/Xt5T8c27sbUzI827Bpn6pSVCoFMtlGUI3A4Gm7r3FYdj++vo6qYy9fSL
         7sFw==
X-Gm-Message-State: AOAM531arwxVms5nZ+bHTaYD1N/1J1Bpd2Wl6Z1IyPUysTlv5xz7Fjkz
        hseizEcJrNsbosfFiUDXhMLFGHRcWVWV1tmtj6haFA==
X-Google-Smtp-Source: ABdhPJyEyS19l/rBk/OtEhxkYjWkowMwfjtY+zPzabBZVyeCZ2VNTvSFAtUJyFOigXbcTktkrJa6rpE3ZN3Azh4mQq8=
X-Received: by 2002:a9d:6e09:0:b0:5ad:1fcd:bfd0 with SMTP id
 e9-20020a9d6e09000000b005ad1fcdbfd0mr22496944otr.312.1646399804477; Fri, 04
 Mar 2022 05:16:44 -0800 (PST)
MIME-Version: 1.0
References: <20220222120054.400208-4-andrew@daynix.com> <202202230342.HPYe6dHA-lkp@intel.com>
 <20220304030742-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220304030742-mutt-send-email-mst@kernel.org>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Fri, 4 Mar 2022 15:09:02 +0200
Message-ID: <CABcq3pF9566uzh2oQF1u8EF_LgFQ0azhzD+2xX4CfqB=MhKCOQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] drivers/net/virtio_net: Added RSS hash report.
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kernel test robot <lkp@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, kbuild-all@lists.01.org,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
Yes, I'll prepare a new commit later.

On Fri, Mar 4, 2022 at 10:08 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Feb 23, 2022 at 03:15:28AM +0800, kernel test robot wrote:
> > Hi Andrew,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on mst-vhost/linux-next]
> > [also build test WARNING on net/master horms-ipvs/master net-next/master linus/master v5.17-rc5 next-20220217]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch]
>
>
> Andrew,
> do you plan to fix this?
>
> > url:    https://github.com/0day-ci/linux/commits/Andrew-Melnychenko/RSS-support-for-VirtioNet/20220222-200334
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
> > config: i386-randconfig-s002-20220221 (https://download.01.org/0day-ci/archive/20220223/202202230342.HPYe6dHA-lkp@intel.com/config)
> > compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> > reproduce:
> >         # apt-get install sparse
> >         # sparse version: v0.6.4-dirty
> >         # https://github.com/0day-ci/linux/commit/4fda71c17afd24d8afb675baa0bb14dbbc6cd23c
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Andrew-Melnychenko/RSS-support-for-VirtioNet/20220222-200334
> >         git checkout 4fda71c17afd24d8afb675baa0bb14dbbc6cd23c
> >         # save the config file to linux build tree
> >         mkdir build_dir
> >         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> >
> > sparse warnings: (new ones prefixed by >>)
> >    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
> >    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
> >    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
> >    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
> >    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
> >    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
> >    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
> >    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
> >    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
> > >> drivers/net/virtio_net.c:1178:35: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected unsigned int [usertype] hash @@     got restricted __le32 const [usertype] hash_value @@
> >    drivers/net/virtio_net.c:1178:35: sparse:     expected unsigned int [usertype] hash
> >    drivers/net/virtio_net.c:1178:35: sparse:     got restricted __le32 const [usertype] hash_value
> >
> > vim +1178 drivers/net/virtio_net.c
> >
> >   1151
> >   1152        static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
> >   1153                                        struct sk_buff *skb)
> >   1154        {
> >   1155                enum pkt_hash_types rss_hash_type;
> >   1156
> >   1157                if (!hdr_hash || !skb)
> >   1158                        return;
> >   1159
> >   1160                switch (hdr_hash->hash_report) {
> >   1161                case VIRTIO_NET_HASH_REPORT_TCPv4:
> >   1162                case VIRTIO_NET_HASH_REPORT_UDPv4:
> >   1163                case VIRTIO_NET_HASH_REPORT_TCPv6:
> >   1164                case VIRTIO_NET_HASH_REPORT_UDPv6:
> >   1165                case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
> >   1166                case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
> >   1167                        rss_hash_type = PKT_HASH_TYPE_L4;
> >   1168                        break;
> >   1169                case VIRTIO_NET_HASH_REPORT_IPv4:
> >   1170                case VIRTIO_NET_HASH_REPORT_IPv6:
> >   1171                case VIRTIO_NET_HASH_REPORT_IPv6_EX:
> >   1172                        rss_hash_type = PKT_HASH_TYPE_L3;
> >   1173                        break;
> >   1174                case VIRTIO_NET_HASH_REPORT_NONE:
> >   1175                default:
> >   1176                        rss_hash_type = PKT_HASH_TYPE_NONE;
> >   1177                }
> > > 1178                skb_set_hash(skb, hdr_hash->hash_value, rss_hash_type);
> >   1179        }
> >   1180
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
