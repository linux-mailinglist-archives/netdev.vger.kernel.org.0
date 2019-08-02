Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417C9802AE
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 00:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbfHBW0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 18:26:10 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34718 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729919AbfHBW0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 18:26:09 -0400
Received: by mail-qt1-f194.google.com with SMTP id k10so6384190qtq.1
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 15:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=WW2IGqIhICVQU16C1ct624+3lC3vhr3vbeWHd8gpPwo=;
        b=TlJ5L8kG065qlx3kok9uMspcKyr0xVQUygOHQuH8rQaTNp1OjCFmzprkFjI2Y82nbS
         7Av+Tuag3qQc/jXyPlW7nNa8BvMottA2QniPnzHCBGPD1XFL375u5uFwdeP8oLGfbjCn
         aPCpUboXRcvBgkbyolxwm8JsEdUF9CseyrJRVzV/BBcxGga11bQYuZhJ1HHdKogi5hhg
         mIw/O9YHoGDhSoAJkF3CI2i1BRWRoVMmhEznZ0LjfE5lHpXosSAT1pKNJGkRFDsv0v9o
         G0+Y1b+LFUkNyOcNB9TKr5M6oBGiESTGUPK9IPHebl+HivQ5x7V14TBdWFnJ+JigbWjM
         Emyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=WW2IGqIhICVQU16C1ct624+3lC3vhr3vbeWHd8gpPwo=;
        b=Y/LXUj7z3Spc5mFarfXLWNGYWu9XRMeAmngkYFg3p3I73OxpAScA7NcLID1sVjiUeB
         P+e+gBaj959vcnjyPKbmg1YVRBRlTSfVTdXnMVFWj1o402pKMYRTW8U8WoMYuU5woerF
         5UjUt3xXLIFL6cisnFU/huPe5ou9oLFZuAmq4xb/VCRCiKwwD3kJtXw8kLusThOHuzXA
         wET7hDDKMto1c8z2ib3VqpsfvcDU8Os3LVuvzSjh35KpuF8PNO/lVG3+f1yBca0c/x6F
         QJ7s1v/WGoLhcxQehCcU5b6rsC4DJqsuvlfM51mRDfOnV1nS41qEoqE2oPbkvmbZCoik
         Jkzw==
X-Gm-Message-State: APjAAAXToMBfgER/F0IV++hCiXK6gxL0gRWVYR1HhJolATqIyXIW0gDq
        9FQz4wZMqMzG4O6IPU+zuOuyRQ==
X-Google-Smtp-Source: APXvYqzJrOLKmEQBq0mvlisQE+9X+CJX0jHdvp6TwIgEbRDBzIj/TdUNhU9kSQuwHTc9motfP82T2A==
X-Received: by 2002:ac8:23c5:: with SMTP id r5mr99897585qtr.319.1564784768703;
        Fri, 02 Aug 2019 15:26:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y194sm34417836qkb.111.2019.08.02.15.26.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 15:26:08 -0700 (PDT)
Date:   Fri, 2 Aug 2019 15:25:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net 0/2] flow_offload hardware priority fixes
Message-ID: <20190802152549.357784a7@cakuba.netronome.com>
In-Reply-To: <20190802220409.klwdkcvjgegz6hj2@salvia>
References: <20190801112817.24976-1-pablo@netfilter.org>
        <20190801172014.314a9d01@cakuba.netronome.com>
        <20190802110023.udfcxowe3vmihduq@salvia>
        <20190802134738.328691b4@cakuba.netronome.com>
        <20190802220409.klwdkcvjgegz6hj2@salvia>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Aug 2019 00:04:09 +0200, Pablo Neira Ayuso wrote:
> That patch removed the reference to tcf_auto_prio() already, please
> let me know if you have any more specific update you would like to see
> on that patch.

Please explain why the artificial priorities are needed at all.
Hardware should order tables based on table type - ethtool, TC, nft.
As I mentioned in the first email, and unless you can make a strong 
case against that.
Within those tables we should follow the same ordering rules as we 
do in software (modulo ethtool but ordering is pretty clear there).
