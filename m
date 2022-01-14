Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E2548EEA8
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243581AbiANQuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbiANQuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:50:13 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BCEC061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 08:50:12 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id iw1so10667220qvb.1
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 08:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=wtTQ9WBDBwDSvfu6oKIkILg6vorrn5QPW5+kcMwi4hw=;
        b=qGSHZgCn0viByPWrXKr6booJglqWAJo79skFmLwdR8JZEu33ES7P4VrJJEyCF/Ngct
         nwQd4fRiV9uRiElaaiogrA/VhtIU03c9j7UwNqTyc+YbEGGsCQ6LotDgHwNMRjGq514x
         I0sg1wEkWNaD07lDSMV0y/5TrfP8MjrUIG+4fRNW2CUrbJ/6jHUXzYa9D3bOkZ+vSeq8
         Ot0zbEmgxONXIDbpG6oo/k9jLwEfStPecKdFOsNXRGLm2jyhtlsHhZWItwIsm7gkw3bT
         GUD3KLlH13SQ0lI/e4ce6h+TMGgPhvNwhnafxJwymyFiCtUYfNHu/nxeIAQ5lNbmR4LD
         n5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=wtTQ9WBDBwDSvfu6oKIkILg6vorrn5QPW5+kcMwi4hw=;
        b=qzZYUFc61PDcp862FvJrxhgTA+DQM3xeJ2rUcu5Qnzdt+eILwViO2UYt1yyAWxLM2r
         pKGsaAmQsg6LxwL3wwE6cKp0gH0fmtq2tG6tSL4WoLVlpwjMNz/3OmQUdzIHIbMjkm2a
         xNtPNestruT2iVBaKHNX3ViUofdugnLp7jddvxaD8LLEZG0xlPRhp4MeRbLujr7iNF6G
         te2C1K79XVQUXeQxFa5SrqyC4NMYj8Csqg2EAdQ3YgY+/Y9JtldXHwcvJEJQmLv1b6Vt
         e3PzXs/V+hdep1n+kRfW/BqTdQyWpy6bKxtUF0JKvuUrLdBANpMd0qDZ2x16sWaJnUCW
         03Kg==
X-Gm-Message-State: AOAM533qEi/2nBMe7aJbCs4OUeH/sJU/vP+mXxDZ54tw7SIOh+M7NegI
        OF8tQg28f+lXBVCw+OIHEitcuBvtOXeQfg==
X-Google-Smtp-Source: ABdhPJwex/giWWtUX5vWvQfF+K/egye2vvgpkqIa1WQD7x5X3/Qw9j2FGYHYZVbjBK8LxPzjUCKlbg==
X-Received: by 2002:a05:6214:19ec:: with SMTP id q12mr7385802qvc.2.1642179011305;
        Fri, 14 Jan 2022 08:50:11 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id e24sm2205975qka.27.2022.01.14.08.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 08:50:10 -0800 (PST)
Message-ID: <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
Date:   Fri, 14 Jan 2022 10:50:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Port mirroring, v2 (RFC)
Content-Language: en-US
From:   Alex Elder <elder@linaro.org>
To:     Network Development <netdev@vger.kernel.org>
Cc:     "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
In-Reply-To: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a second RFC for a design to implement new functionality

in the Qualcomm IPA driver.  Since last time I've looked into some

options based on feedback.  This time I'll provide some more detail

about the hardware, and what the feature is doing.  And I'll end

with two possible implementations, and some questions.



My objective is to get a general sense that what I plan to do

is reasonable, so the patches that implement it will be acceptable.





The feature provides the AP access to information about the packets

that the IPA hardware processes as it carries them between its

"ports".  It is intended as a debug/informational interface only.

Before going further I'll briefly explain what the IPA hardware

does.



The upstream driver currently uses the hardware only as the path

that provides access to a 5G/LTE cellular network via a modem

embedded in a Qualcomm SoC.



        \|/

         |

   ------+-----   ------

   | 5G Modem |   | AP |

   ------------   ------

              \\    || <-- IPA channels, or "ports"

             -----------

             |   IPA   |

             -----------


But the hardware also provides a path to carry network traffic to

and from other entities as well, such as a PCIe root complex (or

endpoint).  For example an M.2 WiFi card can use a PCIe slot that

is IPA connected, and the IPA hardware can carry packets between

the AP and that WiFi card.  (A separate MHI host driver manages the

interaction between PCIe and IPA in this case.)



        \|/                PCIe bus --.     \|/

         |                            |      |

   ------+-----  ------   ----------- v ------+-----

   | 5G Modem |  | AP |...| PCIe RC |===| M.2 WiFi |

   ------------  ------   -----------   ------------

              \\   ||    // <-- IPA channels

               -----------

               |   IPA   |

               -----------



In the above scenario, the IPA hardware is actually able to directly

route packets between the embedded modem and the WiFi card without

AP involvement.  But supporting that is a future problem, and I

don't want to get ahead of myself.



The point is that the IPA hardware can carry network packets between

any pair of its "ports".  And the AP can get information about all

of the traffic the IPA handles, using a special interface.



The "information" consists of replicas of each packet transferred

(possibly truncated), each preceded by a fixed-size "status" header.

It amounts to a stream of packets delivered by the IPA hardware to

the AP.  This stream is distinct from "normal" traffic (such as

packets exchanged between the AP and modem); but note that even

those packets would be replicated.





I originally described this feature as "port mirroring" because it

seemed to be similar to that feature of smart network switches.  But

the "mirroring" term was interpreted as a something Linux would do,

so at a minimum, that's the wrong term.  Andrew Lunn (and others)

suggested that WiFi monitor mode might be a good model.  I looked

into that, and I don't think that quite fits either.  I really think

this should be represented separate from the "normal" network

devices associated with IPA.





Below I will describe two possible implementations I'm considering.

I would like to know which approach makes the most sense (or if

neither does, what alternative would be better).  On top of that I

guess I'd like suggestions for the *name* for this (i.e., what

should I call the interface that implements this?).



The two alternative implementations I'm considering are a network

device, and a "misc" (character) device.  In both cases, a user

space program would open the interface and read from it.  The data

read would just be the raw data received--a stream of the (possibly

truncated) packets together with their "status" headers.  I envision

either one could be a source of packets processed by libpcap/tcpdump.



My preference is to use a network device.  I think it fits the

"stream of packets" best, and existing networking code would take

care of all the details of queueing and packet management.  One down

side is that this is not a "normal" network interface--there is no

reason to associate it with an IP stack, for example.



A misc device would avoid the interface being treated as a "normal"

network device.  It could present all packet data to user space, but

the IPA driver would have to manage buffering, including limiting

the amount of received buffers.  Implementing this would be fine,

but I think it would just be nicer to use the network model.





So bottom line, given what I've described above:

- Is a distinct network device a reasonable and acceptable way of

   implementing this feature?  If not, why not?

- Would implementing this as a misc device be preferable?  Why?

- Is there a better alternative than either of the above?

- Can anyone suggest a name for this functionality, something that

   is meaningful but would not be confused with other existing terms?



Thanks.


					-Alex
