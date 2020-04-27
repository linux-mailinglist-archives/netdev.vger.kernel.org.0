Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3C11BA9FB
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 18:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgD0QTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 12:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726499AbgD0QTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 12:19:46 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36977C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 09:19:46 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id o127so19497402iof.0
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 09:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZDtOrWnHxs8EGSrvAY+FbXgXlLh0SUQO45Pbg/qqIEk=;
        b=h98xEQs1s3mVNhJ7+54/B/sDQ1ewzPneUlGcxuTj4C61UDVhjKs17ApaXnXbu1hpqd
         uI3+gnajA/TYHZkfhYGkmBwbrv0efJQbxJmxC8Qsz4q0Zv/mZ04r7OqFvtMgssgPFAAc
         qVdFPbbGhvCOp/OVUCKw8bMsgyjls0B0juyF2DwN1kVT+heYCXC0/jG2dbebIeCum8d/
         Jp9fl2MjriCRS/8IPKIWrijOVRZegPRvDCaeZd8mYv86ikHDhzdInlC4DQSQXlJjEp/V
         Iedr5HAEHQO13vV7KPjRjWRS1h7Ywjpc7lpuK2MGmKMF12mu1YqzVnWGw3TGUBmCgQt6
         BPpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZDtOrWnHxs8EGSrvAY+FbXgXlLh0SUQO45Pbg/qqIEk=;
        b=rBtjMzNDbS3SwZKJICcvBKquKpgmqjkE9wk1PqY2E1g9GV604R0BK0VAPJoRjn6gWP
         9VFQKwCA1OueOgcRiciAY1El/hQW5RF0y/Q3kimXvHKA4gJNunhrpkhAihDrRwD11Am5
         BStFIal5nLf2mYfOIPRU0l3IunLcO/XHyVsrd9970PgiXeD2w6oL62jxuEI45+bUXvwg
         iIXx0e+2PNBzvQUnemZ3NgO6YpKGjn4AwbYsETXLJwoG7SKsMdb2utnIJrSWD+qAETgF
         MeQDoVLsxnaG0UjeUUOYW0lFiaQ2CApngb0CT2EHx/YtuYebLHKdEr2kdTcdtcvqhlvJ
         +ZQA==
X-Gm-Message-State: AGi0Pua11htxag2id4sH9gJ97zy4YnlDp+TbfflmYce0oVjpOI+6h9ah
        FL5mk2Jx4Mlo6VC0U3dLvNM=
X-Google-Smtp-Source: APiQypKtoaFu5ZnVqe0PrgiIBAAickG2Hz/B9QjXrzlZfiTS0y8BU9+aJheIzsVLg23mG2s7Nyo7yA==
X-Received: by 2002:a05:6638:401:: with SMTP id q1mr20721805jap.50.1588004385147;
        Mon, 27 Apr 2020 09:19:45 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b71sm5620809ill.75.2020.04.27.09.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 09:19:44 -0700 (PDT)
Date:   Mon, 27 Apr 2020 09:19:35 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Message-ID: <5ea70617d8812_a372ad3a5ecc5b81@john-XPS-13-9370.notmuch>
In-Reply-To: <20200424201428.89514-2-dsahern@kernel.org>
References: <20200424201428.89514-1-dsahern@kernel.org>
 <20200424201428.89514-2-dsahern@kernel.org>
Subject: RE: [PATCH v3 bpf-next 01/15] net: Refactor convert_to_xdp_frame
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern wrote:
> From: David Ahern <dahern@digitalocean.com>
> 
> Move the guts of convert_to_xdp_frame to a new helper, update_xdp_frame
> so it can be reused in a later patch.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
