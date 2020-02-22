Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B1C168D7D
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 09:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgBVIHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 03:07:32 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37165 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgBVIHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 03:07:32 -0500
Received: by mail-lf1-f67.google.com with SMTP id b15so3215774lfc.4
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 00:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hzC+iG/oyJjv3THfv1I/jf7+K3Zw7rQSSMvCn0Q5wek=;
        b=dElYs2s/V6VdvlppVTRrTTqkQ6NalURs6E4P5uWaVXhGgqcYqgDUIhWycCtfvW6lyZ
         7gyFE1fHN857VolJTjhR5CK7nDuJh1LF5wrelD92DfzMg0dY4wuKSXE0cp/J3G8M5rJ9
         JvrlMmsKtT3JkhyLby9h1ClV2MOCJoTarHGs85+FHr+0hNhMunBreE/sVXnsIqVrlmWj
         WpLpaKOIJO6RsFlyBC4EsHjZTNg+3z93PGRbv3oLKpe0UfKy6QWf/o5ljynvlejAXRzk
         Kd8VGYUi+jHFieZoDfXTBdrEi7oB8k2InHd2rBDXiUFWa8XvnX1bfr/7Bzh9te041WPI
         81HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hzC+iG/oyJjv3THfv1I/jf7+K3Zw7rQSSMvCn0Q5wek=;
        b=Indxvpi1rj44MY3RupIswnt/F//7kBspQrWK5tBU8wa7Kwz+fI24MfP0r3uN/pqawb
         oT3JlDSYp03EL370GlvnaNoJKY3a4DrQ8Y4fPmxrRcJQIy5wmX5c3ab4+G6MWG26Bw4V
         truOtdIuPjc3Rr+2dBM/HAFHDdhnJ4BqX0rlCeJdUHxPOLbFuc4hGPxnBYwIn/Uowtbu
         xwLOGDxOsDn4+a2hoFr+8EXnKm+hogTJNSy1vUJ0fw3/kHwg38HeFS8kedkDGPlQ75OK
         pzD6YVawBn8m55U/6WjWcKIhYgKbt+D0hAtfQcfk9ePQPBQqxPk8BtHoIK2JvLy3EdMy
         fOqQ==
X-Gm-Message-State: APjAAAWZxo5gQBRcy2kLr1qirNA27yvxypgrtB/YBE+jWgztXWr1eJqv
        gLQLeGLxloDRU/s12+8JTDK+hg==
X-Google-Smtp-Source: APXvYqzrOTDVbMsnuFI9EFJOpT0pOc45Y/1L+cmOupEr5lb/sygY12rElWpGxSLE8SViRIKZw2oTBA==
X-Received: by 2002:a19:dc1e:: with SMTP id t30mr21888399lfg.34.1582358848504;
        Sat, 22 Feb 2020 00:07:28 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:802:eb36:9ce2:7d3:5a4d:6f62? ([2a00:1fa0:802:eb36:9ce2:7d3:5a4d:6f62])
        by smtp.gmail.com with ESMTPSA id u16sm2813938ljo.22.2020.02.22.00.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 00:07:27 -0800 (PST)
Subject: Re: [net PATCH] net: Fix Tx hash bound checking
To:     Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net
Cc:     alexander.h.duyck@intel.com, sridhar.samudrala@intel.com
References: <158233736265.6609.6785259084260258418.stgit@anambiarhost.jf.intel.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <c0740c47-8b2e-8554-c78d-90461dde1177@cogentembedded.com>
Date:   Sat, 22 Feb 2020 11:07:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <158233736265.6609.6785259084260258418.stgit@anambiarhost.jf.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 22.02.2020 5:09, Amritha Nambiar wrote:

> Fixes: commit 1b837d489e06 ("net: Revoke export for __skb_tx_hash, update it to just be static skb_tx_hash")
> Fixes: commit eadec877ce9c ("net: Add support for subordinate traffic classes to netdev_pick_tx")

    No need to say "commit" here. And All tags should be together (below the 
patch description).

> Fixes the lower and upper bounds when there are multiple TCs and
> traffic is on the the same TC on the same device.
> 
> The lower bound is represented by 'qoffset' and the upper limit for
> hash value is 'qcount + qoffset'. This gives a clean Rx to Tx queue
> mapping when there are multiple TCs, as the queue indices for upper TCs
> will be offset by 'qoffset'.
> 
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
[...]

MBR, Sergei
