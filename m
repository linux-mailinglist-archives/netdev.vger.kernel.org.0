Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05196D6006
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 14:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbjDDMTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 08:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbjDDMTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 08:19:24 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D533A9D
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 05:14:42 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id i9so32582799wrp.3
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 05:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680610480;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5HTOSB/1QUkBzIvIrp2UNO6mgnwwP6CDVbSgoIAf2hg=;
        b=p1CHom7k0ZtSYnPolLtszH2Kd8zvZVrNrit4Bbi3aosSCHYjH1Gzd34kr9p77OLmBm
         JMzxXRo9V+If21Vn01kzQbBLIHTRZYfeVtKDJMhBtkdAeBm4mXvi+sUIAgUwqAy++7be
         Vlg+8p49g21HHfU8wiOaIrSuGx3dCM83/PIf5WbV9IDqoVaFlXgM09J+eRJemacc0Yxr
         LieWbDBjcSmchYgI0HEqXoGfQqwgwXomOGdyc59yHCmE9VZKR3WOYAAuMVzhDexgwJBj
         0VMHQ2TJD5n9BADVG00903fhkZlb9HM49z5vxi6O/WXfpHtVTHgzE456mILQiiSFLqge
         cd0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680610480;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5HTOSB/1QUkBzIvIrp2UNO6mgnwwP6CDVbSgoIAf2hg=;
        b=2X3+9N+3PlsfedEAJoJmun1YJFqxxdXR2OLlrfnlBuw8K0y80lvuiH0L6XKyyA4QBz
         FtxSqfwvvtSLdoHAxQl/iys7txlzvS5HFmwpS0REtlSmgqYsAPCn6C+S5Nk6lb4WYA+Z
         nOs22sDGE8do94pSH5kbZOhKDh597HrVYNLxF7Hk9vdMDrs76BeA2BqL7pqOXjDkxgCm
         PtZGRkZc7zn3IL2M7Ut9JedyrzbjKF84CMTWECSBjdrG8vYXHOqgYzhl/tEiWKPCD28/
         6cWusEIhGDX9WSc0X7jIDKmlbgarQR8VxSUlk0RTJjzq8gQhVUmFwxg5Rnslf/cLFWZK
         pqew==
X-Gm-Message-State: AAQBX9fVdeeqL5I1adhm7X0nZARt+AnilK1iy0mx0hcxakoNrkWnYETT
        mDmGdjKPetAU1LGtOmSHCR4=
X-Google-Smtp-Source: AKy350bnTpxuPVttzkCP9sWrRbL0VL8aprSwym/gUi2Gnep3RKWhZo944g3peW+ok3D6GcDM11fofw==
X-Received: by 2002:a05:6000:1cd:b0:2c5:4ca3:d56c with SMTP id t13-20020a05600001cd00b002c54ca3d56cmr16259381wrx.0.1680610480700;
        Tue, 04 Apr 2023 05:14:40 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id b13-20020adff24d000000b002c573778432sm12063735wrp.102.2023.04.04.05.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 05:14:40 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 3/6] net: ethtool: let the core choose RSS
 context IDs
To:     Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
 <00a28ff573df347ba0762004bc8c7aa8dfcf31f6.1680538846.git.ecree.xilinx@gmail.com>
 <20230403145406.5c62a874@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <ecd752db-ff2a-6948-2ff8-531343f80696@gmail.com>
Date:   Tue, 4 Apr 2023 13:14:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230403145406.5c62a874@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/04/2023 22:54, Jakub Kicinski wrote:
> On Mon, 3 Apr 2023 17:33:00 +0100 edward.cree@amd.com wrote:
>>  	int	(*set_rxfh_context)(struct net_device *, const u32 *indir,
>>  				    const u8 *key, const u8 hfunc,
>> -				    u32 *rss_context, bool delete);
>> +				    u32 rss_context, bool delete);
> 
> Would it be easier to pass struct ethtool_rxfh_context instead of
> doing it field by field?  Otherwise Intel will need to add more
> arguments and touch all drivers. Or are you thinking that they should
> use a separate callback for the "RR RSS" or whatever their thing is?

Initially I tried to just pass in ctx with the new values already
 filled in.  But that breaks if the op fails; we have to leave the
 old values in ctx.  We maybe could create a second, ephemeral
 struct ethtool_rxfh_context to pass the new values in, but then
 we have to worry about which one's priv the driver uses.
(We can't e.g. just pass in the ephemeral one, and copy its priv
 across when we update the real ctx after the op returns, because
 what if the driver stores, say, a list_head in its priv?)

And if we did pass a struct wrapping indir, key and hfunc, then
 any patch adding more fields to it would need existing drivers
 to check the new fields were unused / set to NO_CHANGE.

So I think we just have to accept that new fields will mean
 changing all drivers.  (There's only half a dozen, anyway.)
And doing that through the op arguments means the compiler will
 catch any driver that hasn't been updated, rather than the
 driver potentially silently ignoring the new field.

> And maybe separate op for create / change / delete?

Good idea, that would also elide renaming the legacy op.

> And an extack on top... :)

Sure.
