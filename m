Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD43F3AFA7D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 03:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhFVBQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 21:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFVBQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 21:16:25 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5386FC061574;
        Mon, 21 Jun 2021 18:14:10 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id i94so21611858wri.4;
        Mon, 21 Jun 2021 18:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKGpqBSae3SQn5FXwUHkM5Y5Zy1QUuaeOYx04RqOUvw=;
        b=NsQGP6vTQiB8xPTvgdgwiwUf+uIKxW9qgKOxA7tnEbiNVfdqwPQ4Xa4aLgy/bR6ZjC
         7Xi2FmPn8yw1jkJWtddhsAxxKyu9Plwj61IhYD839/rgokoRl02DAD5dFY2iHcQ/Ch+a
         b2+gL8HRVWxPKX0h1IiyJrvT4aU2Yq3z2I39BR0eiX9BBBijajizwK37IW3GQRlEdz8d
         u8lm9cNOy9kj3PV6rKaVjnlv5IM4I1AtmPfefULB1hmiHAPXRIrGMwYg6tXVGrWWEiBQ
         XhIh5pJyWQ+MjZcaCAl/0pBMUhMMG98gnofRZnb/ZV4816Nov9oNew3wOvKPDFbiWF5r
         7PNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKGpqBSae3SQn5FXwUHkM5Y5Zy1QUuaeOYx04RqOUvw=;
        b=GirmLS6MQvEqD+eZeMuF/tcuFVqdVeeZsZPPo72l9uMf8AozT3H2+JRaiXHSpNuIBf
         7PZlpN1MLfnCct+7wvlbSd3rdhe3fWml+9okJkolZlRCFfDDH7STpZ3txGFi1iNlqsv1
         LxGRd1qKF3LDQHdnqcZ3SwjQui56Ha2ZxhZ6APwlPQXOqVskYTpXdiixsC2CopErmRvp
         NIec91C5FA4ccci04Wlb6lbFPvJYsVvWXWCrJfVKJpjmL5oooihaGKq8qrL8fzcDgWFt
         ezduDY8W3njCs9kz/4m0bTmFttDFgmusdD3XJv/qBlwZabiFipErmY9nFIpjfw83P+LC
         6/+A==
X-Gm-Message-State: AOAM530Bo6knidp582n9KUswhfR3IUvrUuWxsHQT/F/IwND22ZGPjsk1
        Y+vUBGLYnUqGRBf5sRqyknZOJ2Lz4bUqXuBrdsw=
X-Google-Smtp-Source: ABdhPJxUI/4c4cpW9zuyZDxEj0yUVCZv1Ub+4FqshB2g6pGOnGOi+3UW/hfVfVzR5ml+jmwLqLksoa71RmtolIGudV4=
X-Received: by 2002:a05:6000:2a3:: with SMTP id l3mr1390712wry.395.1624324448810;
 Mon, 21 Jun 2021 18:14:08 -0700 (PDT)
MIME-Version: 1.0
References: <66a73fb28cc8175ac80735f6301110b952f6e139.1624239422.git.lucien.xin@gmail.com>
 <202106211151.QDS54KHu-lkp@intel.com>
In-Reply-To: <202106211151.QDS54KHu-lkp@intel.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 21 Jun 2021 21:13:59 -0400
Message-ID: <CADvbK_dCgaqrr=pxZGfBmm=3m31+eKgcfkU7AowFbnZAcC92bQ@mail.gmail.com>
Subject: Re: [PATCH net-next 06/14] sctp: do the basic send and recv for
 PLPMTUD probe
To:     kernel test robot <lkp@intel.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a "set but not used" warning, I can fix it after.

Thanks.

On Sun, Jun 20, 2021 at 11:50 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/sctp-implement-RFC8899-Packetization-Layer-Path-MTU-Discovery-for-SCTP-transport/20210621-094007
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git adc2e56ebe6377f5c032d96aee0feac30a640453
> config: i386-randconfig-r023-20210620 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/0day-ci/linux/commit/fcac1d6488c8bc7cb69af9e8051686a674d94fc3
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Xin-Long/sctp-implement-RFC8899-Packetization-Layer-Path-MTU-Discovery-for-SCTP-transport/20210621-094007
>         git checkout fcac1d6488c8bc7cb69af9e8051686a674d94fc3
>         # save the attached .config to linux build tree
>         make W=1 ARCH=i386
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> net/sctp/output.c:215:16: warning: no previous prototype for 'sctp_packet_bundle_pad' [-Wmissing-prototypes]
>      215 | enum sctp_xmit sctp_packet_bundle_pad(struct sctp_packet *pkt, struct sctp_chunk *chunk)
>          |                ^~~~~~~~~~~~~~~~~~~~~~
>    net/sctp/output.c: In function 'sctp_packet_bundle_pad':
> >> net/sctp/output.c:219:20: warning: variable 'sp' set but not used [-Wunused-but-set-variable]
>      219 |  struct sctp_sock *sp;
>          |                    ^~
>
>
> vim +/sctp_packet_bundle_pad +215 net/sctp/output.c
>
>    213
>    214  /* Try to bundle a pad chunk into a packet with a heartbeat chunk for PLPMTUTD probe */
>  > 215  enum sctp_xmit sctp_packet_bundle_pad(struct sctp_packet *pkt, struct sctp_chunk *chunk)
>    216  {
>    217          struct sctp_transport *t = pkt->transport;
>    218          struct sctp_chunk *pad;
>  > 219          struct sctp_sock *sp;
>    220          int overhead = 0;
>    221
>    222          if (!chunk->pmtu_probe)
>    223                  return SCTP_XMIT_OK;
>    224
>    225          sp = sctp_sk(t->asoc->base.sk);
>    226
>    227          /* calculate the Padding Data size for the pad chunk */
>    228          overhead += sizeof(struct sctphdr) + sizeof(struct sctp_chunkhdr);
>    229          overhead += sizeof(struct sctp_sender_hb_info) + sizeof(struct sctp_pad_chunk);
>    230          pad = sctp_make_pad(t->asoc, t->pl.probe_size - overhead);
>    231          if (!pad)
>    232                  return SCTP_XMIT_DELAY;
>    233
>    234          list_add_tail(&pad->list, &pkt->chunk_list);
>    235          pkt->size += SCTP_PAD4(ntohs(pad->chunk_hdr->length));
>    236          chunk->transport = t;
>    237
>    238          return SCTP_XMIT_OK;
>    239  }
>    240
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
