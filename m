Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC9B559EFD
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 19:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiFXRFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 13:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiFXRFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 13:05:41 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDDB4A3CD
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 10:05:40 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 9so2956030pgd.7
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 10:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JPkO5BsRbPVYFHaf9gF2Y632fd3taUEW4OyUqGh3Ino=;
        b=IxfKxcMsSayPozj/fgyIo9ZhKhpi/U1N+Sgv/Id3Kt7C/wpR64vzUi9NoifeeKbaxP
         1e1J+SVdoNnoLpodQ4FonnV0ty08cCpqrSXzeZ/UDfpQbtyWx/QL2A1sHxQyH3c4qkdB
         niuGuvjMrTWpk4XMqB8tJPJNjTGWHU/TRD46v7159wx+OAGx2dzwMu2X8lv+uZ0Ou6E1
         tPjB7SfBZerU+zNuMroHN1bisZjks6SNR+KIQBf4U42+K0Tl6D64xeKNk18JINcLTLZj
         eTHB74xDaU2NaHAixDtHb4kPGNu3nLOmMa3ukfRXVMb0od10QzzPxS2Cej6ShsladLLE
         CByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JPkO5BsRbPVYFHaf9gF2Y632fd3taUEW4OyUqGh3Ino=;
        b=M5OtiAmHPbV3a9Cetg203d0J8GhenLRQaKKZvdhpuzJ9IfCGifg8Iec1Ky7lQjIBy4
         oW8sv0X7KpdYiEamoIEqaY46utLGTQQ/DFIu3rahuPNhJjJnjfG6gVRJggAV9bPNFEDG
         xjFjSFBQrvpYjiaa76VQJojlyPzT520MUEi09DX1bdw6zJ1sfi7d2RaWG3YLuojvsZ1W
         ku7tWsRWYDXszbEtIw6gxbW+Sz+4T06kCVI9WMivBTQQXWhv8z+EUBmus+TaEVHh+5H2
         J6FFgZQSU3U1spzOMvpN6BWBnSkw2a9U4erEAwHllXH9WRFcemuUCSpsXgKPZLu+yeXA
         DebA==
X-Gm-Message-State: AJIora+vTlZ9dljYH1yf0uwZzt7YEB+JEgyWHzJvPgwdOv0KoR76qcCN
        GpMqIOWlooIwhPYT80WOeXbXrWw/OqIjfsuG
X-Google-Smtp-Source: AGRyM1vfwb/W04yFcwUUAHh48AjDueBc9WdQZSOeUkvg680h4f/R7e2uLUq92yGAu5S1Lt4ihMROOQ==
X-Received: by 2002:a63:6ec3:0:b0:40c:450f:2f83 with SMTP id j186-20020a636ec3000000b0040c450f2f83mr12808859pgc.220.1656090339707;
        Fri, 24 Jun 2022 10:05:39 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id x20-20020a170902b41400b001676dac529asm2052628plr.146.2022.06.24.10.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 10:05:39 -0700 (PDT)
Date:   Fri, 24 Jun 2022 10:05:36 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     James Yonan <james@openvpn.net>
Cc:     netdev@vger.kernel.org, therbert@google.com
Subject: Re: [PATCH net-next] rfs: added /proc/sys/net/core/rps_allow_ooo
 flag to tweak flow alg
Message-ID: <20220624100536.4bbc1156@hermes.local>
In-Reply-To: <20220624165447.3814355-1-james@openvpn.net>
References: <20220624165447.3814355-1-james@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jun 2022 10:54:47 -0600
James Yonan <james@openvpn.net> wrote:

> @@ -4494,6 +4496,7 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
>  		 * If the desired CPU (where last recvmsg was done) is
>  		 * different from current CPU (one in the rx-queue flow
>  		 * table entry), switch if one of the following holds:
> +		 *   - rps_allow_ooo_sysctl is enabled.
>  		 *   - Current CPU is unset (>= nr_cpu_ids).
>  		 *   - Current CPU is offline.
>  		 *   - The current CPU's queue tail has advanced beyond the
> @@ -4502,7 +4505,7 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
>  		 *     have been dequeued, thus preserving in order delivery.
>  		 */
>  		if (unlikely(tcpu != next_cpu) &&
> -		    (tcpu >= nr_cpu_ids || !cpu_online(tcpu) ||
> +		    (rps_allow_ooo_sysctl || tcpu >= nr_cpu_ids || !cpu_online(tcpu) ||
>  		     ((int)(per_cpu(softnet_data, tcpu).input_queue_head -
>  		      rflow->last_qtail)) >= 0)) {

This conditional is getting complex, maybe an inline helper function would
be clearer for developers that decide to add more in future.
