Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C1333F852
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhCQSqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhCQSpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 14:45:50 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07352C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 11:45:50 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id u10so477367lff.1
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 11:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=c1Vo+PFUeE9aRuUhu23/K3obSvmo0kuOl6bgQ+yRO3o=;
        b=SnreKLt+o4KUAB9hZr1ouxCqW/G/JdJq5hpyGgN6b8z5oQyeybcwL7r7784GzI1fqe
         sAuMamQKzsMK1TzVvAy1D0FoclGSmasTHjJwjPBbaZb9H2YzU4Zrn5LsWYkUIngZnn+C
         QNa6snfpvnnuoXYq1sQmS0gQuco8lZxcPi1YvTHLgMNCvgxSYBFpoWkTAP9nywCtS7iW
         mAOSu9AdJDacDlnTsglzsQA2gpDzZvj9ZkPJZMyKrvQxonzq5agxq4S3NLB6nAurloxA
         W+bhiKH4M4Xl1hIN+KB+MXHY+fwy+rbMMq0ub1Wb2m4h1nUI7Qq0CthVL/dx+u4w1kvu
         4XTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c1Vo+PFUeE9aRuUhu23/K3obSvmo0kuOl6bgQ+yRO3o=;
        b=MAHmVoSxaYiHOs9EUl7vVEJuqgRpegvCqX8Iel2xyZxh6GqmPHJhx7EtWLsK7ByWkQ
         ip04zxnL8MgiVIAUCM3gRjqHqTX4u5XQDcO3Ns852sao1B2f8XhYtVYsZ2VSjUN4J6fh
         TAaHm2IUrDJUDegBGAVVdp3GzQZLjTRHI15OIlB35CfCvCzSZo6cIQlTh6F8oMSRTOTe
         f25eObMsQVqEu1cJzPQcNeub+54dohvTO8/neDbbzXMINjRu6mKmsBhyay2uUyaXCCuu
         yx6BAohzqC2yS4FNsAX8mmzduas7iBzBDaVaiQQ1E9x6IsnngUxATBfPU5jYJ/O5IR6/
         PQ3w==
X-Gm-Message-State: AOAM532tnR548vRMWd2wRQ9MwHTx3tLXMhc9RaaEdlcwrE6q9FvDTN4E
        YI7buKfMQbESt0xk3SlZV+YgCqr13L1hC4lt
X-Google-Smtp-Source: ABdhPJwwi3K7a6WxKrtQNjX7RZUV69M8/Aw5po8WjHpNJ7MFo02COfVbE9f3YQmz3sSmfy9HT0DzyA==
X-Received: by 2002:a05:6512:ad4:: with SMTP id n20mr3203927lfu.507.1616006748214;
        Wed, 17 Mar 2021 11:45:48 -0700 (PDT)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id r23sm3500582lfm.73.2021.03.17.11.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 11:45:47 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Offload bridge learning flag
In-Reply-To: <20210317141224.ssll7nt64lqym3wg@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com> <20210315211400.2805330-5-tobias@waldekranz.com> <20210317141224.ssll7nt64lqym3wg@skbuf>
Date:   Wed, 17 Mar 2021 19:45:46 +0100
Message-ID: <87k0q5obz9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 16:12, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 15, 2021 at 10:13:59PM +0100, Tobias Waldekranz wrote:
>> +	if (flags.mask & BR_LEARNING) {
>> +		u16 pav = (flags.val & BR_LEARNING) ? (1 << port) : 0;
>> +
>> +		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
>> +		if (err)
>> +			goto out;
>> +	}
>> +
>
> If flags.val & BR_LEARNING is off, could you please call
> mv88e6xxx_port_fast_age too? This ensures that existing ATU entries that
> were automatically learned are purged.

This opened up another can of worms.

It turns out that the hardware is incapable of fast aging a LAG. I can
see two workarounds. Both are awful in their own special ways:

1. Iterate over all entries of all FIDs in the ATU, removing all
   matching dynamic entries. This will accomplish the same thing, but it
   is a very expensive operation, and having that in the control path of
   STP does not feel quite right.

2. Flushing all dynamic entries in the entire ATU. Fast, but obviously
   results in a period of lots of flooded packets.

Any opinion on which approach you think would hurt less? Or, even
better, if there is a third way that I have missed.

For this series I am leaning towards making mv88e6xxx_port_fast_age a
no-op for LAG ports. We could then come back to this problem when we add
other LAG-related FDB operations like static FDB entries. Acceptable?
