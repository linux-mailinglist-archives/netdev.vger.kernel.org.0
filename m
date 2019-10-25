Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B5EE5628
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfJYVww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:52:52 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:42656 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYVww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:52:52 -0400
Received: by mail-il1-f195.google.com with SMTP id o16so3091835ilq.9
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 14:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U/XWgTNc45a7TLQZXtrXyswOpLPgr5RcFtG6hODuS8E=;
        b=gfxNYywipcWP7EuMxw2bJwVSbSfONWb/fDvOSG/um+JMb1KylliAil3I74JAnBhJd3
         YcX15Tz083jX4tdAA8du5dtVof7n6Dg9KxPVMNFLDTCccCtZkYHEKaddF/NhPkY3wNv+
         INvwZLCGnSpbp53B1x+dKWvjh2VnYg0O5C6u16qIuZlaTfCq0GP6VaZyN9FihLXp6nr/
         G0rT0FirIK7YTQwWGX5f8syMkutnFL/iBP4RZ48QjJYVa8FXlQGGY1EL+NrbohYH21vI
         cvRjha5HlhrxEGj7vUiBPhKBZS2B+vQC2nF25c2JT5zHER8oKXFYYSLqbuxIawIs5WAY
         YQ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U/XWgTNc45a7TLQZXtrXyswOpLPgr5RcFtG6hODuS8E=;
        b=ohMe0YPu6OyeSzI+5do2QWev6rbzul6w4tv8lCWJREWWloRM19CTNgGqV//ePFrOr9
         AByjaWv7ZmLf21gJIgcpk/yd5+z1JSADzxladAtmgo4MZ6Wx1R3vu7fDeJ5gL8RyOZdz
         DO1ulopq/9uWPc9iHY1g3TFClQICSzbKTOdbC0859/Iuf6BqEpLk9OzJTyllZaj6sBbp
         eGx4CwYfs6NscLbusx4rrsSQ4pl1FX3Ry3CwD/RMMHtMxo/cX7z5zEudkdaN2e2wxC5w
         vsjVGn8xpG3sA7jE4T7l50yT+o/4ArcHduRlmQEq+G+pwnLcc1z+VpVZJeGW78yyOuh0
         CbDg==
X-Gm-Message-State: APjAAAXrCpRhFChDHB9rGI/lBRaddoj7PRIlMeQnMTpFaD3041dPssKu
        S3XmGRsijW3y0Wm+Vv4ZIyO9IA==
X-Google-Smtp-Source: APXvYqxCwi/ReIsPZGGXbZwMUBZeL45jhvs7ZUToBFgZfin/2LfyoF+n0g9dwev+ybd++QxQ2GWv6g==
X-Received: by 2002:a92:d211:: with SMTP id y17mr7033417ily.28.1572040371527;
        Fri, 25 Oct 2019 14:52:51 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id t74sm499001ili.17.2019.10.25.14.52.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 14:52:48 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
 <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
 <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
 <vbfpniku7pr.fsf@mellanox.com>
 <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
 <vbfmudou5qp.fsf@mellanox.com>
 <894e7d98-83b0-2eaf-000e-0df379e2d1f4@mojatatu.com>
 <d2ec62c3-afab-8a55-9329-555fc3ff23f0@mojatatu.com>
 <710bf705-6a58-c158-4fdc-9158dfa34ed3@mojatatu.com>
Message-ID: <fcd34a45-13ac-18d2-b01a-b0e51663f95d@mojatatu.com>
Date:   Fri, 25 Oct 2019 17:52:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <710bf705-6a58-c158-4fdc-9158dfa34ed3@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-25 5:10 p.m., Jamal Hadi Salim wrote:
> On 2019-10-25 5:05 p.m., Jamal Hadi Salim wrote:
>> +    if (!root_flags && tb[TCA_ACT_ROOT_FLAGS]) {
>> +        rf = nla_get_bitfield32(tb[TCA_ACT_ROOT_FLAGS]);
>> +        root_flags = &rf;
>> +    }
> 
> 
> 
> !root_flags check doesnt look right.
> Hopefully it makes more sense now....
> 

For completion:
It compiled ;->


cheers,
jamal
