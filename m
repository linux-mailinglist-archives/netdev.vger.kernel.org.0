Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6479C7D19D
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbfGaW6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:58:02 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34327 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbfGaW6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:58:01 -0400
Received: by mail-qk1-f195.google.com with SMTP id t8so50497490qkt.1
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=b6LcCyJhbsqjpOjfwkJdnYtVb3I9MsaRbx275CE2vjI=;
        b=JQNyCZnHmvF+qza5HzimpNP5PKfaegR5bTgKGIMVxOT5tZKPgOZQAoVA5G5PtMFjSq
         NHzEXgrAErQ/BKwMDKkEuxZicJRxViTuDLFS30iNhJtM45W2J+zxv6GaNIb0Jemp3qnY
         gVxpne3AWAvSeSX39bq/W9E6j6A5pyqiRQZTvywcJpOJcrgwHzkr4KnAj2ZDofLKsX8M
         eK9wKIXWnTvfqxQLlKwYwRXHeG1jfp+5wpE9AmL/xtdXwLMnJr13Umij1eazHkE74cbS
         GaSzqIP7imLsDYjGuAK1S2dCKTx1XUgByaayG3P9KrOEsbEWakvMDhNnfCsDRNdZTw4b
         CX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=b6LcCyJhbsqjpOjfwkJdnYtVb3I9MsaRbx275CE2vjI=;
        b=YN+6WwvoY/BC9xF0QXltCDtA8DuKLx96gxvS4NgCCe057q4Js/tTApGSVbHFwqtQiY
         R5lpnqqbztjPkpEWTS4xwVrXq11CnMuv4HARUtLdC1F484AW+Vmf12jome/MDF/RHxgP
         hnruD/CmjV902bAtPPt7G4FoM+x8FrJ82xaTNIAjiRuLGEbDTu3iTZ2EB8L33B0WHZIC
         k5tVIkOnF90WNBICpbf4K8qG2BHNNsfI/e5KZMLzYbsrgWxoxcjJId1KcE0dPn3VElNq
         kTUuygguovKV1w3yBx8y3YaqS+xZLSES8HczG1+1YZBkqnqW63u/x+EnMJ0SdjoeWtY1
         PehQ==
X-Gm-Message-State: APjAAAVWvYbzMXrvpaRm97nUw8D7A//PiedVqacK2xM/dzzpeXFLqTy6
        FBrs7j5muOwHcB53CJOmcRABpw==
X-Google-Smtp-Source: APXvYqyZodVCXBtb1KrIZr2Gvk1tSXPt/Wn+t7xVqNCWBJ2ckMskzpYKjB/7WKeJnnU6FVW2NXfSSQ==
X-Received: by 2002:a37:5445:: with SMTP id i66mr86428489qkb.369.1564613880901;
        Wed, 31 Jul 2019 15:58:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x8sm31383737qka.106.2019.07.31.15.57.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 15:58:00 -0700 (PDT)
Date:   Wed, 31 Jul 2019 15:57:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, marcelo.leitner@gmail.com,
        wenxu@ucloud.cn, jiri@resnulli.us, saeedm@mellanox.com,
        gerlitz.or@gmail.com, paulb@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: map basechain priority to
 hardware priority
Message-ID: <20190731155746.40c6d612@cakuba.netronome.com>
In-Reply-To: <20190731121656.27951-1-pablo@netfilter.org>
References: <20190731121656.27951-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 14:16:56 +0200, Pablo Neira Ayuso wrote:
> This patch adds initial support for offloading basechains using the
> priority range from -8192 to 8191.
> 
> The software priority -8192 is mapped to the hardware priority
> 0xC000 + 1. tcf_auto_prio() uses 0xC000 if the user specifies no
> priority, then it subtracts 1 for each new tcf_proto object. This patch
> reserves the hardware priority range from 0xC000 to 0xFFFF for
> netfilter.
> 
> The software to hardware priority mapping is not exposed to userspace,
> so it should be possible to update this / extend the range of supported
> priorities later on.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I don't know the nft code, so perhaps my question on v1
was nonsensical, nonetheless I'd appreciate a response.
NFT referring to tcf_auto_prio() is a bit of a red flag.
