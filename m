Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3CD47457D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbhLNOrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235009AbhLNOrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:47:15 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43CEC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 06:47:14 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id p23so24488977iod.7
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 06:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=WYpoto+Dm03sadJMpeG7gW+PbSOU7j79LwICjvTpTOo=;
        b=ekvWJtbZ4nwFFjXhJHabCpMH5sXheJHdKiLlzm6z2fVTJ+p6+Ab/Ys9lZlEw9EjDZf
         5FmlKi36nCqL0jkMN3YpL6vbalfTQ+bTZYP2HWTyCVFlF3+MxI19DlmkooRQHdvg6Opu
         NxSHHgMdiCZf/Z5hFYb3RIYEU7OpTG87v89uPCnncUF06AfnHoLESbBfrUZcc+zgt2Mv
         9CWD4GC7c9EgOMxcUEKmiqCIqpUtDskAF9D1jPN7LdIdMclmZ4qCiH7Onvx3+2cLym6v
         2o+a+iyhtzWt/kCkLPbdaxqPFg8Uy3HUYf2OHPfHeTFIj5Toc4p0Usl2ZM5v89EQTc4W
         hEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=WYpoto+Dm03sadJMpeG7gW+PbSOU7j79LwICjvTpTOo=;
        b=a2ZddhVsOY1Ax81qhs/hUne3eeCz8bFBTdh32t3ZCn8m+2fVlQGFy4GYSKVHCagP2s
         8b15Tr+aZ8YScdTz7M7hdAxt87+3V2r2RO0pkaCIjEHr9VqsLBtN5klpFJRGGOtxBzJV
         4faox7gqDzt+6asFiug4WaM8pRHjjAnf6ix88A80mEbFVet31FCLlEDQErkZ4GuXK9i2
         u7t8XT1VDib1jGNCUvCrb95VkThf7SQ+cMtYXoinUOlzzfsn5WEIFQuNV35d1KilaXxn
         686AbOG2s8/L4Dzg9cSnnVj1Y6gW0Q5gvEiHTSN/hHlZKyDftBg8dUq0QD6zJsmDLjwq
         jlIQ==
X-Gm-Message-State: AOAM532doXCh7Jq77Tv55NWSD5/6GSa4Z2EBRLXeYcxHHd2nUhEOkPVI
        uPxa9jLms8vKizhqjd8xMqxprgOLl46clbhp
X-Google-Smtp-Source: ABdhPJzaTgf2kNm7+6MQasXpvDIo+mmk632r/GOQxCm4LZtSWtJ43O3HhO00tZFayUR3bAfOkZ0crQ==
X-Received: by 2002:a05:6638:12c8:: with SMTP id v8mr3118769jas.223.1639493233708;
        Tue, 14 Dec 2021 06:47:13 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id b13sm1351619iof.54.2021.12.14.06.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 06:47:13 -0800 (PST)
Message-ID: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
Date:   Tue, 14 Dec 2021 08:47:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Content-Language: en-US
To:     Network Development <netdev@vger.kernel.org>
From:   Alex Elder <elder@linaro.org>
Subject: Port mirroring (RFC)
Cc:     "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am implementing what amounts to port mirroring functionality
for the IPA driver.

The IPA hardware isn't exactly a network switch (it's sort of
more than that), but it has the ability to supply replicas of
packets transferred within it to a special (read only) interface.

My plan is to implement this using a new "ipa_mirror" network
device, so it could be used with a raw socket to capture the
arriving packets.  There currently exists one other netdev,
which represents access through a modem to a WWAN network.

I would like some advice on how to proceed with this.  I want
the result to match "best practice" upstream, and would like
this to be as well integrated possible with existing network
tools.

A few details about the stream of packets that arrive on
this hardware interface:
- Packet data is truncated if it's larger than a certain size
- Each packet is preceded by a fixed-size header describing it
- Packets (and their headers) are aggregated into a buffer; i.e.
   a single receive might carry a dozen (truncated) packets

Here are a few specific questions, but I would love to get
*any* feedback about what I'm doing.
- Is representing this as a separate netdev a reasonable
   thing to do?
- Is there anything wrong with making a netdev read-only?
   (Any packets supplied for transmit would be dropped)
- Are there things I should do so it's clear this interface
   does not carry IP traffic (or even UDP, etc.)?
- Should the driver de-aggregate the received packets, i.e.
   separating each into a separate SKB for reading?

I might have *many* more questions, but I'd just like to make
sure I'm on the right track, and would like both specific and
general suggestions about how to do this the right way.

Thanks.
					-Alex
