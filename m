Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D066BED14
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjCQPeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjCQPeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:34:23 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8371DE1902;
        Fri, 17 Mar 2023 08:33:43 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eh3so21880263edb.11;
        Fri, 17 Mar 2023 08:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679067222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vco4+qW5a0X8eRJOY0dcIZHS++IQaiyeogu6t5HV9oA=;
        b=DdDYwHNsOPzQPMrbcOjApyE5k1OS/YtLNNbB9xqpqaHG3iSdoZrhxvZk7wp1pGDMb+
         jVEJwR9Qrp03SfHNwaDc6mumK5S1eZnUDALoN1AkuYXOGrAgVCLNBq/soGLH/319ojZF
         mYK5xwTjzXacmHFu/CizkKIa4LsWf8t92kayC9b9/wfXFtcpw2AZzKUz68PtoxNMTWNA
         UuK6snX2A5zzBADF9TOfF6hKMCulrTZrYvIsjLWcShIC0v9OCX0gH7yajW7y+Q3tEEhk
         YwDvnxdtugAeQeI25KY94o9oH6lB/jE6W4FyZooOpY3bMy2TN8SgbRj8b0VNLQvbZ46I
         DV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679067222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vco4+qW5a0X8eRJOY0dcIZHS++IQaiyeogu6t5HV9oA=;
        b=6SX+QOVYD3tvr9UatpSWk0EFndlnGx51Q4DFV5iUVPofwkUzYq3adxRh2m533Xjd6k
         dUvkLi4ZGVRseRjpqeKFQMzyDj/JHmoPQK4PM7qkYS3SPMtxuKgWQEYpTkYqiZZXSX7j
         wVwC2SK/6pH0/h2SJT6v4DUKuE8qgw4aRkdPFks312ghQjToIVF62CZTzKSoHkeKGB/g
         jCRfAlJzP6eV6XupgW77TNdQG3EMHC2l/YO54fmSPgF0Q0UvnCYciqv4/pTMUvTiYFUu
         XA/VKhGeWb8dcQWyzJnw/idcbZu/g1j6vbxz7+23fXM5LIYZe9W1lzKgYThQ14aqoE9x
         Hfng==
X-Gm-Message-State: AO0yUKUJrTgNOQLIbdVGvmxsn9buYFnj33CzxSX+L5gaS/ccZxPqQ23N
        t3Nut/PbPx/PK5V05DcNMEuItvT0mbdv2w==
X-Google-Smtp-Source: AK7set99hu91DP4G+H0AA/K7ZdG9n47atXoIszqKsP3ORQmKjXsItzSzOMC01Qdrc9aM22y7LyLtRA==
X-Received: by 2002:a17:907:72d2:b0:930:af71:eae with SMTP id du18-20020a17090772d200b00930af710eaemr7859787ejc.66.1679067221787;
        Fri, 17 Mar 2023 08:33:41 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id k6-20020a17090632c600b00924d38bbdc0sm1102091ejk.105.2023.03.17.08.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 08:33:41 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:33:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/4] net: dsa: mv88e6xxx: mask apparently
 non-existing phys during probing
Message-ID: <20230317153339.a73rkwgx56hn3ct5@skbuf>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
 <20230315163846.3114-5-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315163846.3114-5-klaus.kudielka@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 05:38:46PM +0100, Klaus Kudielka wrote:
> To avoid excessive mdio bus transactions during probing, mask all phy
> addresses that do not exist (there is a 1:1 mapping between switch port
> number and phy address).
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Note that on Turris MOX, the PHYs are described in the device tree, so
the MDIO bus is not auto-scanned and this patch has no effect, therefore
I won't add my Tested-by tag here.
