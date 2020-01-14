Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D6C13B00D
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgANQxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:53:42 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33719 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbgANQxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:53:42 -0500
Received: by mail-qk1-f194.google.com with SMTP id d71so12786177qkc.0
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f8ZdMZ1BS3aK0eDev5KldCmx7KcdNZN/UQ+7XtW/aqA=;
        b=PUzelXAoI5TjMVnykFB4tdf0SzFYY08HScf9jPX4dI6ofPUxy6MFhNInrqQTFoMQ9x
         JXZ2r+afDsrdLUPHMqOcWONPjxiKx05dTPgRPJdQyH7avOnBoUJWvam/6dWFDjX7L/J0
         B/pdsz/UirHJAgv3AqEYcVkkpb/OIo+PV2iucJBDZEN5HhquzE7vN1IdB7gUL21Za9ag
         uc3IlQTxklGtKmU0kw//wBZJYQgXmzRx9VXyorxyMtjA9KXqtS4PQpnIf6Owf9UpKLlg
         uXNLZF4Ygrj9OvIf/J72+hriWk3+YpidsAZjJVKosvGAc37UYxKXcmGwPAcj2MvfuuX2
         aVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f8ZdMZ1BS3aK0eDev5KldCmx7KcdNZN/UQ+7XtW/aqA=;
        b=nfIm5LPhxPVyad6s052ildLphy/71Q5q7emsoY/e4VZklayFCNOFirQDCbbnXaGhpv
         iF2Hs+pYCcsbpDoTQCL4N2b0aegfs3llOxEwR0gOQRv2taFLVERLxvE1/hvMPJqZqUEQ
         fnKnFNoeBjpgKn4JiD6TJyEhErJQb96pDu0/I/zndijl/V49uSFsTreF/iHjTcg+MvrY
         JuVHdLrtCI3CMJoY394vAXFlrT5+IZXzO1HzCBVSRpfF3gWE5MJSSVrfmHpR8WGzPoL6
         QN4tkaI0cO5anhPPVNBvdi0cDB/SLv56MNnyCVQ/2nC+VEgGCIA5PlLdge/ZABiWsTKm
         cdOA==
X-Gm-Message-State: APjAAAWEr1JStkK6YvFakknK3H941bAeQarvAhdBXZSvxkFHbYkBLlZE
        Ifrb4RN//aJqJEpEVC89gHs=
X-Google-Smtp-Source: APXvYqxKYed/TLW46cHyC5xOS8UU5tfLSRUCEhw20sPHnKtFndfsphZ3e43Ob/OCgXKBfIb6+ZfsaA==
X-Received: by 2002:a05:620a:1014:: with SMTP id z20mr22166290qkj.196.1579020821154;
        Tue, 14 Jan 2020 08:53:41 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:cda2:cdcb:a404:13ae? ([2601:282:800:7a:cda2:cdcb:a404:13ae])
        by smtp.googlemail.com with ESMTPSA id r10sm6852694qkm.23.2020.01.14.08.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 08:53:40 -0800 (PST)
Subject: Re: [PATCH net-next 3/8] net: bridge: vlan: add rtm definitions and
 dump support
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
 <20200113155233.20771-4-nikolay@cumulusnetworks.com>
 <20200114055544.77a7806f@cakuba.hsd1.ca.comcast.net>
 <076a7a9f-67c6-483a-7b86-f9d70be6ad47@gmail.com>
 <00c4bc6b-2b31-338e-a9ad-b4ea28fc731c@cumulusnetworks.com>
 <344f496a-5d34-4292-b663-97353f6cfa94@cumulusnetworks.com>
 <d5291717-2ce5-97e0-6204-3ff0d27583c5@gmail.com>
 <aa9878d2-22d7-3bcd-deae-cf9bccd4226e@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <473cb0a5-f6ad-ccd3-9186-02713f9cb92f@gmail.com>
Date:   Tue, 14 Jan 2020 09:53:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <aa9878d2-22d7-3bcd-deae-cf9bccd4226e@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/20 9:50 AM, Nikolay Aleksandrov wrote:
> Ah fair enough, so nlmsg_parse() would be better even without attrs.

that was the intention. It would be a good verification of the theory if
you could run a test with a larger ancillary header.
