Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256902C733
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfE1NA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:00:29 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40262 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbfE1NA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 09:00:28 -0400
Received: by mail-ot1-f68.google.com with SMTP id u11so17624135otq.7;
        Tue, 28 May 2019 06:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nyuMvCRbSUhq6xRTrLcgr4MhHdrWBhaLhwL3jkImdAk=;
        b=kJr6nC6wrPy5BVs3UbPGlGOpYy1mOQInAXwlimyLqnlUIpPK00WuQlilHm9ZkotRJV
         h1pimdnhh82LoIBRfEUIipy8n2O6qQ0YczA6pgyJoYpGCUygXY678yviVL4fhVkEUgsz
         +8nfHCoTn/OZjMT7tRrLdZOZ6h61WdEqz8i77woSak5lD9Htc1qXqrRmxKs87NU0T2WV
         wL0IhC4phxSDwOZ/F2mSVY1uRh7Yc5oaTTly+R19n72jm1/Ap7RexNayfL0Oyrut/+3O
         e4LNIHxFNNQWMXrXIunt+Fz6Mc6Rle4hsvX8CsJoaw5qoAcy6fsz3uQIhJnaq72WOnwM
         K9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nyuMvCRbSUhq6xRTrLcgr4MhHdrWBhaLhwL3jkImdAk=;
        b=p8+ow/gAXKTF/Wd+1yFRaYTFItFLifLRC5qz7uXHLj7/jYh7957QuZtv5bHWxUvveF
         /pmgE8kmZwbPApDAlmTz7c7qSDFLs+VxKFwxPL5/7XaL7qdceqqACfObMeiofQb8VB6e
         SH/k2VTKA6sp7GMvYzeEmv3qyRw8mMDjyqt03yWAFpOLH6rRlqeGhoRaG8GgTBC38OuS
         xmeTZQ8kxDDcBAiMtmXMAOTjw4nBqWs0DUnPBX14Sg/v7ZDbNYj/mEqGpfOAMdVKRl/U
         Vdl9c14N2/qGQUcE1H0VnSa2R1oXFVC6O9QParxv3YU6FwwWvW3dgmXA+ZbCEjHXJTvs
         v7/Q==
X-Gm-Message-State: APjAAAXOKQTyWCC1EmkL5+0kIn4QN4ZXgSid5w6WX4TSjaPwFpPYvaaF
        /RE6887t6bc3q5P858kPN4x/ramx
X-Google-Smtp-Source: APXvYqzCcbSRy8Xk4z+5gflTGtO2qnD2GXWsU7hV9w9ZfqG/x4WuJz1gn0nW5TIGH72uN8BHw9aXeA==
X-Received: by 2002:a05:6830:1692:: with SMTP id k18mr53205otr.73.1559048426883;
        Tue, 28 May 2019 06:00:26 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id f7sm5385458otb.66.2019.05.28.06.00.25
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 06:00:26 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: Fix null-pointer dereferences in error handling
 code of rtl_pci_probe()
To:     Kalle Valo <kvalo@codeaurora.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190514123439.10524-1-baijiaju1990@gmail.com>
 <20190528115555.301E760F3C@smtp.codeaurora.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <2658b691-b992-b773-c6cf-85801adc479f@lwfinger.net>
Date:   Tue, 28 May 2019 08:00:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528115555.301E760F3C@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/19 6:55 AM, Kalle Valo wrote:
> Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
> 
>> *BUG 1:
>> In rtl_pci_probe(), when rtlpriv->cfg->ops->init_sw_vars() fails,
>> rtl_deinit_core() in the error handling code is executed.
>> rtl_deinit_core() calls rtl_free_entries_from_scan_list(), which uses
>> rtlpriv->scan_list.list in list_for_each_entry_safe(), but it has been
>> initialized. Thus a null-pointer dereference occurs.
>> The reason is that rtlpriv->scan_list.list is initialized by
>> INIT_LIST_HEAD() in rtl_init_core(), which has not been called.
>>
>> To fix this bug, rtl_deinit_core() should not be called when
>> rtlpriv->cfg->ops->init_sw_vars() fails.
>>
>> *BUG 2:
>> In rtl_pci_probe(), rtl_init_core() can fail when rtl_regd_init() in
>> this function fails, and rtlpriv->scan_list.list has not been
>> initialized by INIT_LIST_HEAD(). Then, rtl_deinit_core() in the error
>> handling code of rtl_pci_probe() is executed. Finally, a null-pointer
>> dereference occurs due to the same reason of the above bug.
>>
>> To fix this bug, the initialization of lists in rtl_init_core() are
>> performed before the call to rtl_regd_init().
>>
>> These bugs are found by a runtime fuzzing tool named FIZZER written by
>> us.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> Ping & Larry, is this ok to take?
> 

Kalle,

Not at the moment. In reviewing the code, I was unable to see how this situation 
could develop, and his backtrace did not mention any rtlwifi code. For that 
reason, I asked him to add printk stat4ements to show the last part of rtl_pci 
that executed correctly. In 
https://marc.info/?l=linux-wireless&m=155788322631134&w=2, he promised to do 
that, but I have not seen the result.

Larry

