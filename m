Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52482BA15A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 05:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgKTEB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 23:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgKTEB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 23:01:27 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33009C0613CF;
        Thu, 19 Nov 2020 20:01:27 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id m13so8528083ioq.9;
        Thu, 19 Nov 2020 20:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kRf+0fLjXqPi4tn9lMnjFFTRUejoTSHqOHRd70Pcq7o=;
        b=TQZwP4aS11yCae/sz1LF5G8I8UOR79JSSsd/hxaTZJoiyDjCHYC7+U6JYRJq+Vo4HS
         zktQaHnpMta4XwiZ+LfcF9r3qJhFsqPmelYTaBfK/uUw6jMpwFqDap3RjPQZNdb8bwmR
         s2xZbw92wTDHO2di4yMXXYUnLc0L9J9DZbhTHiXsaP1rKk2aJG/68Hu0brqQ5potAi4n
         bSrhtsgCAddcMpxQvQthzSOpct0z+Zmgzbd3svVC0BZGZWPwDxdZsUK0i6ycMZy7Lgw3
         6HLso8/E27uvWIMZ68kPAObPLJJ4AgTU8Zb2+iGPEhadX4zBTxifrJmFnUGwVIoJ56IG
         KxFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kRf+0fLjXqPi4tn9lMnjFFTRUejoTSHqOHRd70Pcq7o=;
        b=CsVUDYc83cxNbYc2a3TQ0jWTX3mIXCHYKpYaYpWShtaz6t63mEVy0wzoN6JbVXQ2+q
         byytPqKjrtEZ2VLlj+CiCrxbKQMRLv6Q+Q5eFJlb8953j7JfusCmBOUysTc2HL6IWPH1
         vVtEGhXpNSVmZE12NSqykaoAzNZaXEJYp8iQeqoUU1FqqHYHFFjOgdvpTLcuGkoDDW1o
         wbguHBwosQplm0Oc/2PQ/G2ivkTBN/yxTloyhzcVFkr1+QaXtslTCgl4vvVhnHtA8fUW
         d3TuLhb9WLfwP/U5V3YtuZK6QwwgUtoWnUcfkq9YM6pkBF64uBY6uFjZxGj10vrPnd5i
         9vew==
X-Gm-Message-State: AOAM532BsNmlkXpORGS6LibYX+q+THT68alj4ShlF+qf2HLgNg1vbmtp
        VkvapKpjldNGzcKV5VIUd+IDMhf4Juo=
X-Google-Smtp-Source: ABdhPJzVAnaLmKeY3QZv5cyXRFE/TFuXiZSxiGaamS++sLb3IFtvDsgdWXS8NGopOFU8dnWiof9ecA==
X-Received: by 2002:a5d:9c87:: with SMTP id p7mr9740236iop.49.1605844886495;
        Thu, 19 Nov 2020 20:01:26 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:7c5d:d56d:e694:8d47])
        by smtp.googlemail.com with ESMTPSA id z9sm753230iog.3.2020.11.19.20.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 20:01:25 -0800 (PST)
Subject: Re: [PATCH v4 net-next 0/3] add support for sending RFC8335 PROBE
From:   David Ahern <dsahern@gmail.com>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
 <b4ce1651-4e45-52eb-7b2e-10075890e382@gmail.com>
Message-ID: <8ac13fd8-69ac-723d-d84d-c16c4fa0a9ab@gmail.com>
Date:   Thu, 19 Nov 2020 21:01:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <b4ce1651-4e45-52eb-7b2e-10075890e382@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/20 8:51 PM, David Ahern wrote:
> On 11/17/20 5:46 PM, Andreas Roeseler wrote:
>> The popular utility ping has several severe limitations such as the
>> inability to query specific  interfaces on a node and requiring
>> bidirectional connectivity between the probing and the probed
>> interfaces. RFC8335 attempts to solve these limitations by creating the
>> new utility PROBE which is a specialized ICMP message that makes use of
>> the ICMP Extension Structure outlined in RFC4884.
>>
>> This patchset adds definitions for the ICMP Extended Echo Request and
>> Reply (PROBE) types for both IPv4 and IPv6. It also expands the list of
>> supported ICMP messages to accommodate PROBEs.
>>
> 
> You are updating the send, but what about the response side?
> 

you also are not setting 'ICMP Extension Structure'. From:
https://tools.ietf.org/html/rfc8335

   o  ICMP Extension Structure: The ICMP Extension Structure identifies
      the probed interface.

   Section 7 of [RFC4884] defines the ICMP Extension Structure.  As per
   RFC 4884, the Extension Structure contains exactly one Extension
   Header followed by one or more objects.  When applied to the ICMP
   Extended Echo Request message, the ICMP Extension Structure MUST
   contain exactly one instance of the Interface Identification Object
   (see Section 2.1).
