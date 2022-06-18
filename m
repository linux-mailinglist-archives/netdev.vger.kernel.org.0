Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2112D550214
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 04:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383872AbiFRCl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 22:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiFRCl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 22:41:27 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBD4579AB;
        Fri, 17 Jun 2022 19:41:26 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p128so6247573iof.1;
        Fri, 17 Jun 2022 19:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9dDTl+0ZieSz3VWQZ/8mBwCv0tA7WWjveLBUXmU1/z0=;
        b=A44l/GWuMVb481G1+N2FIiWAzPmLWORwhmtB5olFB6p/SuErkkZbKor6LTDM8UYEZB
         kH8msvDKvQjMJyIqmmlTIliqibkNwGc6BYG+igQutPbwoElEg7I6BbQy9YrSa3Xjvkan
         jFxIGLfkVXjaBC93FpO/yP/3Gnw3qzHtH6L86lYkZ/CVZ3Mxu0uAj/D5VISP/dSYH/uL
         ETXhYLXtGCifOBRH7n/bris0CQZh9URmySZOdoWkKn3RA+ojO/RZbtUGm5AlZOxnF7KK
         T8B7MpYX9AnJ3YiAuX3QVYbxg+KA3K3URS1VHGb5P3cDhJCrqIU9TYufFbvUPwK+OKGe
         U+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9dDTl+0ZieSz3VWQZ/8mBwCv0tA7WWjveLBUXmU1/z0=;
        b=Iy+gI72IhGSzAcPrGeXQDc7hlnCH8e6rUZo/LcXhoRm7oEfyZu7312Xw2bGr7o7cI3
         bvCB0RV4P8S4lvcOYdowG/rrUxJMJhLW+gqKE1FkzBp+v8qq78vbOVk7KYXukLzfrCrz
         O4gEo43pYc+CknMqN+Lh1l5FjBK0FNH+5Ri5z23y0sYfa85yZ2M+7YOYFdfjQi+H4xSY
         91DZVn82dEJvf0SUAC3v4/60OzHerDVJ0WwyxBe3UOYiqsW99aExNxK6F7DJeFVVUmBy
         kcm1Ka5sLM+4t3/WXdWD+93BPSmfHxw6eBKkx/3VNDdLfF0P7y3C7Tb7Z86hbPHZ1EaM
         AOMQ==
X-Gm-Message-State: AJIora9QYriR3vWqDX1N4KjFK4ziv8LQ8SYr6R1TSqMPjCdG7ihB1nTc
        XXUIUR/gN0/AY7BAte/bhpY=
X-Google-Smtp-Source: AGRyM1uzjwCs05UtKm95SkAhogsr5WB3Zt1aHhj26fdN4a4V71P7YX5QJhxd2u8ey8qQ3X+aRt31Ew==
X-Received: by 2002:a05:6638:3014:b0:317:9daf:c42c with SMTP id r20-20020a056638301400b003179dafc42cmr7234034jak.10.1655520085878;
        Fri, 17 Jun 2022 19:41:25 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id c18-20020a92cf12000000b002d8f398c845sm511816ilo.84.2022.06.17.19.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 19:41:25 -0700 (PDT)
Date:   Fri, 17 Jun 2022 19:41:19 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <62ad3b4f60ece_24b34208d@john.notmuch>
In-Reply-To: <20220616180609.905015-8-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-8-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH v4 bpf-next 07/10] selftests: xsk: introduce default Rx
 pkt stream
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> In order to prepare xdpxceiver for physical device testing, let us
> introduce default Rx pkt stream. Reason for doing it is that physical
> device testing will use a UMEM with a doubled size where half of it will
> be used by Tx and other half by Rx. This means that pkt addresses will
> differ for Tx and Rx streams. Rx thread will initialize the
> xsk_umem_info::base_addr that is added here so that pkt_set(), when
> working on Rx UMEM will add this offset and second half of UMEM space
> will be used. Note that currently base_addr is 0 on both sides. Future
> commit will do the mentioned initialization.
> 
> Previously, veth based testing worked on separate UMEMs, so single
> default stream was fine.
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---

Just curious why can't we make veth use a single umem with double size?
Would be nice to have a single test setup. Why choose two vs a single
size.

Thanks.
