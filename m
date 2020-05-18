Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ABB1D7C47
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgERPD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbgERPD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:03:56 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF86DC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:03:56 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d7so10898612ioq.5
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zhBCLV6Pq+PIRNumJDFC+hT6dCYyurG69WuSPlFC+DE=;
        b=SW4u/tpYmJKb5hF00ZiUK7OHKeHyg8BR91taO3uS78PK3g2ArFVd9a62KZv6xuy8ox
         /kg1mA67VfJUMDPBwmNigfm8eIhITbGuopGqaY1CWn85xlwmQVq71zmFMKFTU6s06wDW
         ycU30OfwVZ0ye2/wpGID46Ev86K9JMmJHXpTE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zhBCLV6Pq+PIRNumJDFC+hT6dCYyurG69WuSPlFC+DE=;
        b=eg8hUG78BMcEjiTCn3K71zyhJxUP401wfmtGQok0NgJkXi5yzigUACBQ/SQVn3UTPn
         FDySqdLlGitGGQ95sTh90ptYxML70dmHvD+Vh8rGTnQ6YCZ5dIDP/L2iAeiz5MKLRMwi
         uin8O8kQcsZIVVHBEt/eAnb/+K+RX28b26wybA0PmsEszIqUCy5fkBWhL6O2MjqG8cL9
         Z6oVR2kfYOIxGuFmcAKueIdORzolrAJQ7UDzRqTpvvjc4fjOCjbVLQr08hzrBeCd4fe1
         0eHEyYgJ+8WB44BrTNRxil2Hfido6bwhSrEZek5NkEWW6nA9hZ2EUjPGtjlE1oo48wHZ
         5XQQ==
X-Gm-Message-State: AOAM531TtHBiQLqt61tofwHrGBnhzJc2mVl4kqgqdFBSwQ30hCHcfL7X
        Gt53KLV6ue/SmAWV2uV+CEL5ww==
X-Google-Smtp-Source: ABdhPJxXUsQQZxuy+jef26vC22p6/tcVRbzM2T2as9hfXdqTCjcvfVhSyuoK9CHzA97x4Kv81uabHg==
X-Received: by 2002:a02:a895:: with SMTP id l21mr15553885jam.82.1589814234911;
        Mon, 18 May 2020 08:03:54 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id q4sm4383395ilk.12.2020.05.18.08.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 08:03:54 -0700 (PDT)
Subject: Re: [PATCH] drivers: ipa: use devm_kzalloc for simplicity
To:     David Miller <davem@davemloft.net>, kuba@kernel.org
Cc:     wenhu.wang@vivo.com, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
References: <20200514035520.2162-1-wenhu.wang@vivo.com>
 <20200514101516.0b2ccda2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200514.124700.630104670938763588.davem@davemloft.net>
From:   Alex Elder <elder@ieee.org>
Message-ID: <a13b6985-98d6-5996-1ef7-6d64cdd75c15@ieee.org>
Date:   Mon, 18 May 2020 10:03:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514.124700.630104670938763588.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 2:47 PM, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Thu, 14 May 2020 10:15:16 -0700
> 
>> On Wed, 13 May 2020 20:55:20 -0700 Wang Wenhu wrote:
>>> Make a substitution of kzalloc with devm_kzalloc to simplify the
>>> ipa_probe() process.
>>>
>>> Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
>>
>> The code is perfectly fine as is. What problem are you trying to solve?
> 
> I agree, these kinds of transformations are kind of excessive.

I have considered using the devm_*() functions, but if I were to
make such a switch it would be done comprehensively, throughout
the driver.  It is not something I plan to do in the near term
though.

					-Alex
