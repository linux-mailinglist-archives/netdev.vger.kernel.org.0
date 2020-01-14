Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E9613AE21
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgANP5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:57:42 -0500
Received: from mail-qk1-f180.google.com ([209.85.222.180]:40515 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgANP5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:57:41 -0500
Received: by mail-qk1-f180.google.com with SMTP id c17so12528127qkg.7
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 07:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/3+1QiEre9YH4cM+tfebVe7TpB43yJC5ge9PRQf3CtE=;
        b=RdDaqhwFPzNyoycAG5hpFT9gIer2XmovzDuOK0FwLLyEXAv7w3gFka8WAE3M1H3BrS
         wumjc931X0UYxiLOZN+iqq/xORi2k23DYTDxA7J4IQqlIVun9pwVqE7+OlFSidhFnI85
         TuzdnAfIq6Bivyy3AwiHKbPNmIVxwu8ARA9xGfG4GU9ZP5DiM028WjEGFyGT7Ll1FlFj
         ExM8VNC2HqJ1aha4yRs6qW/mxA31YZ46d2wAg5qE5OoyJEpZyENKnSVAXR02yjR6QSQv
         hWa5z9iRQWSmyjw/0Efptn78KwH3cEPv69fFLIa+P23e3qp8RSCTvSn/3h3nYPUC2X+d
         JYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/3+1QiEre9YH4cM+tfebVe7TpB43yJC5ge9PRQf3CtE=;
        b=bqdK+XdzqsWhxCdTsKAgrApTHwsoInGL/syFYB+y0uA1mu/Ypkg3r7DTN99AytYlOA
         mNZqA58GNLGlxmTfyuXKJ2+/GZWrn+1CScxRuuYL3jhNUlY3CORwHR80PI/QPfIq1jWH
         sadUDyK+Xy3+tB1UcyN2NwVNFRe7edjPK6TnkY7oFmIb1TlEMOH3Ork1Pu0nt4PaRiEC
         TKStFbSYGK/WM6UTGrWXYqBwK/w+2HsZTj6lU+zuwsSIOtjzko7nqdQnS1bbg072f27a
         8jtdAcPu3/sx075zSbPhFG+gUT+rn1AWu30fHOqgT3SFGNnxfdUZhW45b3HU6wIWXdbf
         Ajyg==
X-Gm-Message-State: APjAAAXJvgZ8r3OSIIDUkFdZzoN7ZcJOW7weX2NWBI3I8k2RKaO7/YU0
        mc2Gn6wCL4zI0rsOmBKXHjMQwRDf
X-Google-Smtp-Source: APXvYqxXm3PCxw7BdEhXFosQTBs1OHtiEspLaeAEYvcCmhgLU1suKURorYE01Qub+6lulqnGiG55yg==
X-Received: by 2002:a05:620a:911:: with SMTP id v17mr17661266qkv.251.1579017460855;
        Tue, 14 Jan 2020 07:57:40 -0800 (PST)
Received: from [172.29.12.10] (mapache.unesco.org.uy. [190.64.137.20])
        by smtp.gmail.com with ESMTPSA id z4sm6750602qkz.62.2020.01.14.07.57.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 07:57:40 -0800 (PST)
To:     netdev@vger.kernel.org
From:   =?UTF-8?Q?Eduardo_Tr=c3=a1pani?= <etrapani@gmail.com>
Subject: Network prefix length for local tunnel address
Message-ID: <bafe4bfa-17e4-14b2-cdde-54938784b257@gmail.com>
Date:   Tue, 14 Jan 2020 12:57:34 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The manual for ip-address says:

 > If a peer address is specified, the local address cannot have a 
prefix length. The network prefix is associated with the peer rather 
than with the local address.

Does it means that the local address has no prefix at all? Or that it 
inherits the prefix from the peer address?

The question arises because I found out I can "duplicate" the local ip 
address, instead of getting a "RTNETLINK answers: File exists".

These are the steps:

# ip tuntap add dev tun3 mode tun user alice group alice

# ip address add 10.8.0.1 peer 10.8.0.2/32 dev tun3

# ip address add 10.8.0.1/32 dev tun3

# ip address list dev tun3
…
inet 10.8.0.1 peer 10.8.0.2/32 scope global tun3
…
inet 10.8.0.1/32 scope global tun3
…

Is that the expected behaviour?
