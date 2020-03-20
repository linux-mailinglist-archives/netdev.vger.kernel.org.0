Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A719118D362
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgCTPyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:54:46 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56246 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgCTPyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:54:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id 6so7065375wmi.5
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 08:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z3Y5obYHPEbnQ4bhdTT4+kfjdmoS9DBt3R34Li6Gg7Y=;
        b=kkSXP+04iuZo7U9M1M3rLKXz1pkq0AVIy/s7CISh9r7V4T5EO1iijzN+QPOJxL1dPH
         2SdCHKI7QoKqkZVUexagBL4/oLt5e/Kbeph294jiQoBxAQrnIyDq+BgEq6UjeQYFsj6t
         CuSG583hbPCZdISP/6eoCuoNo+Vy07B/ZcJaaCmAEVDpEqG4JzuDQXP3zdlG720XqZgV
         N0fdIv1M/lXnk1lZP6AJd6irF5a2LMjuF+1S81poUtxpp96IN15MQmfdxMk9qBHMwsvD
         +BBdeqyE5LMpvXiu6ze5CIYEMiOA/c3C4SGEk5KC5MlJQqSPO9B2SBOkYPEr/Ik3zbfy
         w3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z3Y5obYHPEbnQ4bhdTT4+kfjdmoS9DBt3R34Li6Gg7Y=;
        b=B0LnB9sA/Cbpvq+qu8avra7V8vFqRBJFC0QD2JC5yGcwNr++4fkqa4G+6E71K0MtDR
         AYxR4Iceij6AOCQWYGIuXNZfi9okIqCA1Yor4Tf3AIbFp0dbIsoeiXn+kapMYLp1FSnS
         1NKItveaCfP/fEelVrJ6SkVmXPyKaZ5NcNaC43zsMdy2Fr+JW0revjW8sCOMc6WWFrL+
         xut36HKSZnIWy7pdxNarZVFmNGrCQ+EPHT5vwK+J8V/hhFYqzRMZGhgbHaC8ixDH68yT
         ZGoaJJR6ERdSzf7ddUKaltkUmWERbRrTGKLPbeaWVAuIOrcn1/I9jlEy/sNz+UavQbJc
         HEWw==
X-Gm-Message-State: ANhLgQ233ZySA2r0K/kejRLik1luLCxTad2IlPKdUQWlWybrythj2IFl
        8mzBvZQTJrrpLk5QAytJX9i+TA==
X-Google-Smtp-Source: ADFU+vvbdXACQ4ZPIgOkp9OvYQ3o8s1a3CROGAdQ2mCpGBVz7xs171SaeaRiAhv/4VmCINgipD4DxQ==
X-Received: by 2002:a7b:c404:: with SMTP id k4mr1941025wmi.37.1584719684089;
        Fri, 20 Mar 2020 08:54:44 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (81.243-247-81.adsl-dyn.isp.belgacom.be. [81.247.243.81])
        by smtp.gmail.com with ESMTPSA id c4sm8278449wml.7.2020.03.20.08.54.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 08:54:43 -0700 (PDT)
Subject: Re: [PATCH net-next] net: mptcp: don't hang in mptcp_sendmsg() after
 TCP fallback
To:     Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
References: <9a7cd34e2d8688364297d700bfd8aea60c3a6c7f.1584653622.git.dcaratti@redhat.com>
 <3121516743a4acdb67799565d0251531092244e7.camel@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <b4cc3997-c4d8-2f7c-30c8-1fb6922a910b@tessares.net>
Date:   Fri, 20 Mar 2020 16:54:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <3121516743a4acdb67799565d0251531092244e7.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/03/2020 23:48, Paolo Abeni wrote:
> On Thu, 2020-03-19 at 22:45 +0100, Davide Caratti wrote:
>> it's still possible for packetdrill to hang in mptcp_sendmsg(), when the
>> MPTCP socket falls back to regular TCP (e.g. after receiving unsupported
>> flags/version during the three-way handshake). Adjust MPTCP socket state
>> earlier, to ensure correct functionality of mptcp_sendmsg() even in case
>> of TCP fallback.
>>
>> Fixes: 767d3ded5fb8 ("net: mptcp: don't hang before sending 'MP capable with data'")
>> Fixes: 1954b86016cf ("mptcp: Check connection state before attempting send")
>> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> LGTM, thanks Davide!
> 
> Acked-by: Paolo Abeni <pabeni@redhat.com>

LGTM too, thanks Davide and Paolo!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
