Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361D71C0B9
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 04:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfENCxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 22:53:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39656 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfENCxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 22:53:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id z26so8276661pfg.6
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 19:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ruqSyFlxnOwZud/ocF3jfSRlezdIRCpKdccmXRilrvQ=;
        b=WUtX3dGDbFhv1GgJSax+E9I6ZMMNUf9+6+147p0fq4ZwWiPPgpu8tTbZM/6J+1gyLc
         hKWTElndiEX85DKvwsTlokVEP/3UM3IBFhFjods6R2CO7Nyl+hIZiD+kc02/yjQF/sO7
         OYRviy6+0GHRn+jCM7bUltpya470Dd3gIMehqG9Cxc8XLuTtl9dqnghdefpGzY2Zrb6J
         fGAW7UsQCos5TzMoTQsERd7Mb1CmxZ2qtpNkFyC/2h8bllGLbsQMfuVwwTK0nHjs2lqA
         HfXeqD9n1dtjRbaZTCfyjV7uk8Pk8GeCv0QDPQrysNiUOiSL1fD5j9diodu0GLD0xuGO
         h5MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ruqSyFlxnOwZud/ocF3jfSRlezdIRCpKdccmXRilrvQ=;
        b=WMwS577DpVgcLwoknmSB65JDVmSyF8fiXp05H+TbGzyIX36Egbk47YrhbQrLfPMT1z
         CFdzOhlLHRCTucKU/XFgz/PxupwZO2/IgpgxkDFCsm5HMLQQzmUj5TsbtESC7m6Tjnle
         ZVw+sIVQarizPU+vt7M8iSBaachDQQBgL0fREuk5Xv0YZpQbroqTw1qVEWPytK+47jC5
         y6om5TOlE7LwUsKNicA/i7ixOW/DCT7ROOBg5MprfsUcSc59qke6D2NL0YGRp5JpwSqE
         6d0oKYzbcNhdyO2eUcXBX76rtTVA8nBYK8cd/TkRrI/9LkGZeB8nVi2opSMcG97HA9QW
         z7lA==
X-Gm-Message-State: APjAAAX9NOr9RyVEPosMjBijwXXlOLw4m6USuoZ9cimEEx2YeJey9swh
        4kaHTU78MRRAokk+iC57/nU=
X-Google-Smtp-Source: APXvYqwUQ8sYRPo1fC3VgORBp9xoR7Iqmv5KGsmCoMZjcfzTKwbbss/2l2Z77A8e2VuITwZhU+6yeQ==
X-Received: by 2002:a63:1b65:: with SMTP id b37mr35836443pgm.408.1557802412980;
        Mon, 13 May 2019 19:53:32 -0700 (PDT)
Received: from [172.27.227.184] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id s134sm24888165pfc.110.2019.05.13.19.53.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 19:53:32 -0700 (PDT)
Subject: Re: [PATCH RFC net-next] netlink: Add support for timestamping
 messages
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20190509155542.25494-1-dsahern@kernel.org>
 <CAF=yD-+U+6AVpWfRAznXeaJm5jpQQOT=5kn4=wE900=Eu4QZpA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b0b5dccd-cab0-9896-d6ef-d5f586fbbf9e@gmail.com>
Date:   Mon, 13 May 2019 20:53:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAF=yD-+U+6AVpWfRAznXeaJm5jpQQOT=5kn4=wE900=Eu4QZpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/19 9:31 AM, Willem de Bruijn wrote:
>>
>> +/* based on tcp_recv_timestamp */
> 
> Which itself is based on __sock_recv_timestamp. Which this resembles
> even more closely, as both pass an skb. Instead of duplicating the
> core code yet again, we can probably factor out and reuse it. Netlink
> only does not need the SOF_TIMESTAMPING part.
> 
> 

agreed. My original version went down that path. I'll take another look
for v2.

