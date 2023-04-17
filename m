Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE446E4C93
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjDQPQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjDQPQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:16:05 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDD191;
        Mon, 17 Apr 2023 08:16:04 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id ff18so3166382qtb.13;
        Mon, 17 Apr 2023 08:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744563; x=1684336563;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Njb3nDqiylR1xpil80P1e9sGs4DNK9W/rwC6kpXNNPk=;
        b=cogNwe4nSD8gJhJXPp6ZEL5Md6p5BXdC73TYAFa86y6GESPSH7OOkJv5FvzleIzixZ
         YvPQyj6QI+oLAeXQFVpfdYK+vSo+z44XUiOiP5tCSrqHbjY9rkW5bH+oRCoxXQBxxhA4
         gV4R3u+DqMi0ajJDdFwDvap0S1tMHFur4vivV3YN5bw3GzDp+ZHy7mlZstTVMspEK+dY
         JRtCDLr8zhRZQ0T6z9GrklieSg5uekw8Ajn9q1g4YFR74X9kSNhnfglWwix6XHXl7z2K
         tXfYjTb3vEfjDX4f+ibLB2YvIabfF6OTRkOxOjPt2OdmSNqcBefHLxeS6nO1eTk40Ux9
         vMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744563; x=1684336563;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Njb3nDqiylR1xpil80P1e9sGs4DNK9W/rwC6kpXNNPk=;
        b=bH4JBBxQ+ctxC1zTNy7nebWif0Q500vVRssUQqLjjITso7OzIpYUcgv/yHYW+l8Am1
         wF26vFLsUiBh1K7up0UUCWpCdO9DO624sYTisgeZ3UQQfygzR/fSY5AG7ugP4aTpE/nG
         Uu4WcRja0lcOt/GrlXtq2HhiXxERBYTobB1PSm8g2xFDiTK3v1TniHc2k0QuqfTBtKoe
         ISXf49jWFqFlo2YMeS53rg4pDlXqkxgZYB61mTdoI6fo7UuBK5KeEWz4NKBGZ6GhIsSC
         y3OYY7/z56PKNH8LxIkraB674tteNBdkHFNWzM28yrfDL/If4qtoPeT7LNoc70cL+Wtg
         XJAg==
X-Gm-Message-State: AAQBX9e9HaY2BZ4mbRhkv5FVLnA0462QvCt6YoenmpD4iApe3YPmHXv3
        QhA5Io8ZyGblC2ftNpGXHcE=
X-Google-Smtp-Source: AKy350YmOO+ODOpIwgxzxH8zOmhBZngaKtmCkSvJuNR6otd2m3bfKHixNNMLv5XF0PbqdyvSgkbSXg==
X-Received: by 2002:ac8:7c56:0:b0:3ec:4856:9708 with SMTP id o22-20020ac87c56000000b003ec48569708mr12340263qtv.68.1681744563392;
        Mon, 17 Apr 2023 08:16:03 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 125-20020a370c83000000b0074de7b1fe1csm1227218qkm.17.2023.04.17.08.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:16:02 -0700 (PDT)
Date:   Mon, 17 Apr 2023 11:16:02 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Yang Yang <yang.yang29@zte.com.cn>, davem@davemloft.net,
        edumazet@google.com, willemdebruijn.kernel@gmail.com
Cc:     yang.yang29@zte.com.cn, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org,
        zhang.yunkai@zte.com.cn, xu.xin16@zte.com.cn,
        Xuexin Jiang <jiang.xuexin@zte.com.cn>
Message-ID: <643d62b28e413_29adc929416@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230417122423.193237-1-yang.yang29@zte.com.cn>
References: <202304172017351308785@zte.com.cn>
 <20230417122423.193237-1-yang.yang29@zte.com.cn>
Subject: RE: [PATCH linux-next 1/3] selftests: net: udpgso_bench_rx: Fix
 verifty exceptions
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

Yang Yang wrote:
> From: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
> 
> The verification function of this test case is likely to encounter the
> following error, which may confuse users.
> 
> Executing the following command fails:
> bash# udpgso_bench_tx -l 4 -4 -D "$DST"
> bash# udpgso_bench_tx -l 4 -4 -D "$DST" -S 0
> bash# udpgso_bench_rx -4 -G -S 1472 -v

Why are you running two senders concurrently? The test is not intended
to handle that case.

> udpgso_bench_rx: data[1472]: len 2944, a(97) != q(113)
> 
> This is because the sending buffers are not aligned by 26 bytes, and the
> GRO is not merged sequentially, and the receiver does not judge this
> situation. We do the validation after the data is split at the receiving
> end, just as the application actually uses this feature.
> 
> Signed-off-by: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
> Reviewed-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
> Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
> Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
