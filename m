Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7BA33C783
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhCOUPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhCOUPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 16:15:02 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E66CC06174A;
        Mon, 15 Mar 2021 13:15:02 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u4so18838867edv.9;
        Mon, 15 Mar 2021 13:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Et3bGj7NRUnGYZkgSJXXctmKtTjvcq/IEumqCLrdZqM=;
        b=f65y33FUsrBB5rR2HTKHwiOJcYCIF/Z9KKaxelMcE59WPl0A9th93ojz24HKXhdJtB
         ZW26+Lh3FEiPFYTnOU9lHyOQD2CXxJBU6zxE1EcCk6k/IuPccSgXGblmVkVXxIHUPZvm
         /xVSyjQaisI2UR2nNGp/YkrVoHxNTy1ttDKiThbTyWk4ilQjwQAObDTSPmgGQIFBdepb
         guyjB3JjD75CJrfRH+Vm9sE1KUqeCQYZC7OtqOGbII3+RxUQdG1fLxjQ90fUv2n2zNL4
         T1+Fw8Oh1kaowekT2HvlsPP+yGLC2Oi5spZFm5IA9j+4/t7XelW00frnuN25aetKByXo
         gf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Et3bGj7NRUnGYZkgSJXXctmKtTjvcq/IEumqCLrdZqM=;
        b=qvgb5x2MAXCZUhc30AQlWrLWvMqWm8FBodyZxTZLtu3RGA3xJMXnzE0Z7lTWIJa9T3
         +E0KlvJh18cqNkVUhYDBidS6ephyRuTkBgtIyJ5w415VVWQrR6Q3dz6J1FxPyLfQdEiS
         Jgk8CjUKSvNbU1lL4BnwS3LyA6kpSuTUVa/tsmmnXF8+HPDzEGclSA5Gvlt8Y51pDQz7
         0Dmv/KYMb1PGPXx1ZZ6ppbfH7xFBsTIDJqEq8I4d/CTdZ0UbjLUPBqnec+qkFvAaiNBW
         Onz7CBsftTgTpQtN//58+dC7P33Vr2xZLIwHzxZbwZ6rAGrrd40uRuoyBcdOUPQewbW5
         KhqA==
X-Gm-Message-State: AOAM53107eHgd9I9NlmHO2EM0UsIhSZ+x7B7aZmbXnpQFIrtKDQ+vgxI
        tMCoAUeU5+9egj/zNeOiafw=
X-Google-Smtp-Source: ABdhPJxiY21xokc16EePJATVpAqxEBxUu5/cho/QaM5eIiVQdEIEpGB19T5Tfpqf440nVgTv4kngbA==
X-Received: by 2002:aa7:c345:: with SMTP id j5mr31126866edr.338.1615839300869;
        Mon, 15 Mar 2021 13:15:00 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id h10sm9380114edk.17.2021.03.15.13.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 13:15:00 -0700 (PDT)
Date:   Mon, 15 Mar 2021 22:14:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     'w00385741 <weiyongjun1@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: fix error return code in
 sja1105_cls_flower_add()
Message-ID: <20210315201459.6crxixnuw4jyje7q@skbuf>
References: <20210315144323.4110640-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315144323.4110640-1-weiyongjun1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 02:43:23PM +0000, 'w00385741 wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> The return value 'rc' maybe overwrite to 0 in the flow_action_for_each
> loop, the error code from the offload not support error handling will
> not set. This commit fix it to return -EOPNOTSUPP.
> 
> Fixes: 6a56e19902af ("flow_offload: reject configuration of packet-per-second policing in offload drivers")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---

Thank you for the patch, Yongjun.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
