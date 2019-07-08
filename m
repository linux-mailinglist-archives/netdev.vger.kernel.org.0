Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0E162C96
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfGHXSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:18:18 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41550 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfGHXSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 19:18:18 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so5365916pls.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 16:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=8oHHcJUP7nkJDLIV0GvZjrpU0ij6n6U1uma0RZjduiA=;
        b=LTbF/Ew3riDDlnPr+dKdep3Z2cgMZzhXDVslHvOIRQeocu/0RAqWEgL+FtxVKL/GZG
         COqC9JEsGRJR2meBIN36z4p9eF0rlaqhek4BQX/aKYAahAoAL7Tx637oIAyXL2okMxU+
         YEJGMIj4qxdJuIQwMt/haze/61UIchtYqCAVxlywyP7bkdnZo7mNWj63fg9+kWfTw2b5
         rE5dwEB8yg0iOd11AZr6Su2YYQpWwalkn+90hDN6syRFGuuIWLi4M/exqA+P0SCYDPJr
         tXr5ExzATkcaClFtgVKL2FL7n+/HMRIEgCjKrl3ilmyQw9OR4pN9yuwnpKfJP3v4Q5BY
         RD9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8oHHcJUP7nkJDLIV0GvZjrpU0ij6n6U1uma0RZjduiA=;
        b=iQ+wxYojDO7Q2nP6Mo1ZN6GV/yb545pC90Lw0PSes3D+1XFZFKvpDpkHuHxpgiHTf4
         fcMoe9zDY3YQ/8jZ7M30uy/MB1uN0FHRT1lH/DCFw8f/1HqoOlX14KaFHGO+AlmG8/bn
         sm00z7TZwXT2dkgfN4SKIwhk1OFD9faLOQAhq62e0JgbcWJlqJ4ByzZd9fSNG8J7wi4w
         9CaEGaTqC5SSNt/GjvhtVDDlQuKx0nQeci6qKqRXhVhfakWRtLQgf+1++NzFfXMTX9sV
         X4avfwbmQ5+Zj5gB5z7iTHUkP1HNl87lhl3ky1Al2Lz0E7no5azHSC9PCJUakunwsPV5
         P/jA==
X-Gm-Message-State: APjAAAVQj7W3dElmXdx5n0EJIMHby3HgpUUBY2/f5C59weDieMeby7tO
        v1EtMcIUe8Hegrsbfcm7RTxHgVf8
X-Google-Smtp-Source: APXvYqzIPy5CzbXkN21osZb5UaC0HJ/uqG01kxV679HwPReyeRbzNYdzneu8wogm6DeU84UP8DRenA==
X-Received: by 2002:a17:902:b48f:: with SMTP id y15mr23032722plr.268.1562627897416;
        Mon, 08 Jul 2019 16:18:17 -0700 (PDT)
Received: from [192.168.0.16] ([97.115.142.179])
        by smtp.gmail.com with ESMTPSA id i14sm33700416pfk.0.2019.07.08.16.18.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 16:18:16 -0700 (PDT)
Subject: Re: [ovs-dev] [PATCH net-next] net: openvswitch: do not update
 max_headroom if new headroom is equal to old headroom
To:     David Miller <davem@davemloft.net>, ap420073@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org
References: <20190705160809.5202-1-ap420073@gmail.com>
 <20190708.160804.2026506853635876959.davem@davemloft.net>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <87bfb355-9ddf-c27b-c160-b3028a945a22@gmail.com>
Date:   Mon, 8 Jul 2019 16:18:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708.160804.2026506853635876959.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/2019 4:08 PM, David Miller wrote:
> From: Taehee Yoo <ap420073@gmail.com>
> Date: Sat,  6 Jul 2019 01:08:09 +0900
>
>> When a vport is deleted, the maximum headroom size would be changed.
>> If the vport which has the largest headroom is deleted,
>> the new max_headroom would be set.
>> But, if the new headroom size is equal to the old headroom size,
>> updating routine is unnecessary.
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> I'm not so sure about the logic here and I'd therefore like an OVS expert
> to review this.

I'll review and test it and get back.  Pravin may have input as well.

Thanks,

- Greg

> Thanks.
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev

