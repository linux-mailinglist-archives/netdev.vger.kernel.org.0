Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2A85B2240
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 17:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiIHP3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 11:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiIHP3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 11:29:07 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744F2F1F13
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 08:27:55 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b21so5327427plz.7
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 08:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=e/k0fT/C8CN/ZUPSjSv31/FrSRQtjz30qx1pUPwxd+0=;
        b=VqdIJWb4p40tzfCgckrnFWF7jqaCpe7H8O6mzHlvvLWLCrl4BLj+oc/VNMBgplu9n0
         0MTiUEJgI+HZOvtI+SgSNEtRPTcVZguCsrriXSdKY++J+eYsAGtHOhn5z+wacz1VFHHA
         rqiQaRu9kVxQsWbRkJjMT7+6UCS9JPhFnPmDgDFs24ZLTaMafVCjGeFt/zIK9iqiVuK+
         0tTLA2+t7SFI/Eq5qGJKOMsQ4rCvYyx7MUWYEflrXydiQQMnhKCo/Te9rsXTTXk49zI0
         yeKglRSLXQEuFwwRJWzCNuQFP9lrwZrChA3W33ShKfmy3DGhxGugh0MEnaEw45onAyeB
         hRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=e/k0fT/C8CN/ZUPSjSv31/FrSRQtjz30qx1pUPwxd+0=;
        b=m0ejQCBg3ExIJqjCOix1RIdh9TyZf/Canof0+i2JhDvAK169TS45t1wUTNVwKYyOVd
         ndddE78WK4cIq4sK4syg71w3omgeX8CzbTAULhyjOYrnOq4lQaPL/MYjhKQ+lJTQaYhZ
         5b08PtIPVrOA7+1IePH3gluT2hyTrajA7Z0XNfncC2SqHTiu8s/cRJ/TpV/7YzqVOzMn
         faag52tG4XO7PB7sbB/f5Ec5Ca2EeZoHrVkIIZqrHCokPBa7uNhi7JOfPp+nFDNMbqWe
         gXvIIbswbOgL3r6sE3neHNpzc34xb2nr1GEPQQSS2+tWVsA+HI8xzKWgfjqN3u5z/ZJ8
         6vVQ==
X-Gm-Message-State: ACgBeo2iqdCcpgRvW3sFzuMG/08IZMLv+sab/wZ88SGRJQqSHgMSl/JK
        EC8sauY5AiG/p2lItjsQQE174/Hei7cSEeIFNDY=
X-Google-Smtp-Source: AA6agR5OVyFbLFGBTxyuqfMFGjBhZ4rIZHgbm7uU7jpDmLQ40sapYVaS3fGXV85dv9VxnlDHqvVXNI36xThVXDysjjI=
X-Received: by 2002:a17:902:7fc8:b0:176:8bc0:3809 with SMTP id
 t8-20020a1709027fc800b001768bc03809mr9364906plb.21.1662650874094; Thu, 08 Sep
 2022 08:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 8 Sep 2022 08:27:42 -0700
Message-ID: <CAKgT0UcCrEAfiEi-EVkXAmZxdyD910yr2v54iYe3nzQdaX+6ng@mail.gmail.com>
Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue mapping
To:     Amritha Nambiar <amritha.nambiar@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com,
        vinicius.gomes@intel.com, sridhar.samudrala@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 7, 2022 at 6:14 PM Amritha Nambiar
<amritha.nambiar@intel.com> wrote:
>
> Based on the discussion on
> https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/,
> the following series extends skbedit tc action to RX queue mapping.
> Currently, skbedit action in tc allows overriding of transmit queue.
> Extending this ability of skedit action supports the selection of receive
> queue for incoming packets. Offloading this action is added for receive
> side. Enabled ice driver to offload this type of filter into the
> hardware for accepting packets to the device's receive queue.
>
> v2: Added documentation in Documentation/networking
>
> ---
>
> Amritha Nambiar (4):
>       act_skbedit: Add support for action skbedit RX queue mapping
>       act_skbedit: Offload skbedit queue mapping for receive queue
>       ice: Enable RX queue selection using skbedit action
>       Documentation: networking: TC queue based filtering

I don't think skbedit is the right thing to be updating for this. In
the case of Tx we were using it because at the time we stored the
sockets Tx queue in the skb, so it made sense to edit it there if we
wanted to tweak things before it got to the qdisc layer. However it
didn't have a direct impact on the hardware and only really affected
the software routing in the device, which eventually resulted in which
hardware queue and qdisc was selected.

The problem with editing the receive queue is that the hardware
offloaded case versus the software offloaded can have very different
behaviors. I wonder if this wouldn't be better served by being an
extension of the mirred ingress redirect action which is already used
for multiple hardware offloads as I recall.

In this case you would want to be redirecting packets received on a
port to being received on a specific queue on that port. By using the
redirect action it would take the packet out of the receive path and
reinsert it, being able to account for anything such as the RPS
configuration on the device so the behavior would be closer to what
the hardware offloaded behavior would be.
