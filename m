Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F096180B4
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiKCPKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiKCPK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:10:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60281A380;
        Thu,  3 Nov 2022 08:09:40 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso5519445pjc.0;
        Thu, 03 Nov 2022 08:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TYQSkbtesSkMhkx4ROSMNbPqpw1PNy8BUmQtQA+bWtY=;
        b=dijdhOsu77eKvXnUHftUveI8NwZ1Ehpt1s+21QoMwl9hJSKfkYNlkijrw7517RoVNc
         lrhOqT5oNusRUMg/rDZ/6n5UccBbo7OJkrkyawN66zbQGqsLMhMqrvXUy8l2OPZiTMNI
         7ufe+t33Zk9tYdcf6pftVFcGDbwCk2PAHJ4AzLeX5w7MCrOZ7SSVLafyTtKMZCpEa+XZ
         T01VmDokOsZCIxTPl3lsDHT7tq0XAvoVoM2OrK+fQmEqXRlSiRjai2dNnIh92amI9e4g
         +XunRWJ2Af1UDab7VFqQwSAjwNGVO/NAt4q+dWwl7uJRQw+NU83er0XI0i5xV96+TcKH
         EFdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TYQSkbtesSkMhkx4ROSMNbPqpw1PNy8BUmQtQA+bWtY=;
        b=F5KvRCk6oG65rLmodKeH8uezWNUemhENnrDwSdSHN5cnm0J2NEFniRCu5b0Z3NnLi8
         vuWnpILGKKYo3FQ9XglsEKNZ1KXl8IrYOXAr83E8a81iRKTFabXRqcgZvKyZYBm/h0Cu
         xA3cKVHzoi0th12q+Ujw+dX+D30e0poFDXNWScJowQvuIgG7x7zbbevzNUZs7rPjpAxJ
         KwCijUe1nD5+/ig1yD9iAa4S6SKoVEZ/oRfhGi+aqxCAQGxOFxpZd5K4JGW1X/9htC7N
         JGxFMnCTqlAKOeScpw2OA9MbZyfDH3WwlKCjixEplA20L6vfJZOZHCr0Cl4HZoe0mbnR
         BsIg==
X-Gm-Message-State: ACrzQf2sCZqdtcnp6FDhBtIeqalMWtqbfqBW1pE7KjF4/HZMXdoy7Rpn
        gTcRt5ke5XDLJyyqrHL1xqM=
X-Google-Smtp-Source: AMsMyM6SqR6ACkO3klsnuvux/9Q488rsDcFTmuh1ek/hg4l1rICRFfT/gTPZ4y4ho6jV13S0MvMkBw==
X-Received: by 2002:a17:902:8c92:b0:178:29d4:600f with SMTP id t18-20020a1709028c9200b0017829d4600fmr30829208plo.40.1667488180159;
        Thu, 03 Nov 2022 08:09:40 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:5:8000::75b? ([2404:f801:9000:1a:efea::75b])
        by smtp.gmail.com with ESMTPSA id p8-20020a1709027ec800b0018703bf3ec9sm815459plb.61.2022.11.03.08.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 08:09:39 -0700 (PDT)
Message-ID: <9dced807-952f-1ddd-ad58-f3fc3ec32071@gmail.com>
Date:   Thu, 3 Nov 2022 23:09:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 09/12] hv_netvsc: Remove second mapping of send and recv
 buffers
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
 <1666288635-72591-10-git-send-email-mikelley@microsoft.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <1666288635-72591-10-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/2022 1:57 AM, Michael Kelley wrote:
> With changes to how Hyper-V guest VMs flip memory between private
> (encrypted) and shared (decrypted), creating a second kernel virtual
> mapping for shared memory is no longer necessary.  Everything needed
> for the transition to shared is handled by set_memory_decrypted().
> 
> As such, remove the code to create and manage the second
> mapping for the pre-allocated send and recv buffers.  This mapping
> is the last user of hv_map_memory()/hv_unmap_memory(), so delete
> these functions as well.  Finally, hv_map_memory() is the last
> user of vmap_pfn() in Hyper-V guest code, so remove the Kconfig
> selection of VMAP_PFN.
> 
> Signed-off-by: Michael Kelley<mikelley@microsoft.com>
> ---

Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
