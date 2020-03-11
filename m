Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50582180F00
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 05:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgCKEsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 00:48:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43995 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgCKEsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 00:48:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id c144so561810pfb.10;
        Tue, 10 Mar 2020 21:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+47C+jfpK4xf86InfqEL9pfxOsGcy+6AGjFw8QEEWug=;
        b=iUJvcLXBXSdmIO2io8noAZXPDFGLqDOWY7s3nxLXtarf5N4Xvr/kNzb7YLsEgZmAc9
         xW2OssTCURRCVOCAtwUUdXMmJwxXOZYdWEF64gheBp6IjYNKX+Kcehfied44xmPQvsPy
         jKnurv7g6hWn2FOyeCOhoFTPU2z6eUvKch2+c7LLLck+3ltNYJwax6f+woY/DLTsaIA9
         EgdUPXy26M5j2rVjypMOrmuJtae0XFJ957QznnqsqVVFmPZhRdZIL+V4GMsT+nlntNJK
         j6ZEY8RsQopvo0LOo0Yacd949OYl8LFiDFuYRc47gqDtIjY3fysbntPR19KJ3wxXrkVZ
         M+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+47C+jfpK4xf86InfqEL9pfxOsGcy+6AGjFw8QEEWug=;
        b=Y31/oXBpJXUJeiAb6vWRdPU+LZyUar4M6sPSR+2uiVOl7l4ymyGerT274jnEuAIp+Q
         +RjrzC44nrst3dKjoTmjLxxnYrEkn7N3Qls3Vnh8HLbF3uHOGLV9R1bO7yVOgxdsV3ed
         AViuRfJTsmERdv/rGrFKsvHAPGK8KckXk9Jc5EmqQn71yR3ZPGtGQKq0w3hoY9uFXcm6
         e0Hu6IEMzKn7mOb3xSk6Itjs92Bcic5ybnncbL8YmsmgSPIv5P90QbV7nreljUDtkP6w
         ZSv2OyzHPB3g2MmxWIjXbkTOTdUjunIvMcsxlj+FAdvYMpEJy+lFAGg4oi7zhfesWUgs
         MOTA==
X-Gm-Message-State: ANhLgQ3+h/JHgE9hEmzHAVJKSem5VSIxye23A7fWip4PlYb6i7+bbXeY
        Wchl4dGvlBUo6+CKslt/NPs=
X-Google-Smtp-Source: ADFU+vtChVwk3PRomy0CXWF7QQF1HoQ1qepUrOFkcP3TombcgSqOSPUacm5mcUV1oZHmNNIAINd02Q==
X-Received: by 2002:aa7:9a45:: with SMTP id x5mr1036371pfj.248.1583902101315;
        Tue, 10 Mar 2020 21:48:21 -0700 (PDT)
Received: from [0.0.0.0] ([2001:19f0:8001:1c6b:5400:2ff:fe92:fb44])
        by smtp.googlemail.com with ESMTPSA id h29sm46860236pfk.57.2020.03.10.21.48.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2020 21:48:20 -0700 (PDT)
Subject: Re: Maybe a race condition in net/rds/rdma.c?
To:     santosh.shilimkar@oracle.com
Cc:     netdev <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        haakon.bugge@oracle.com
References: <afd9225d-5c43-8cc7-0eed-455837b53e10@gmail.com>
 <D8EB4A77-77D7-41EB-9021-EA7BB8C3FA5B@oracle.com>
 <94b20d30-1d7d-7a66-b943-d75a05bcb46e@oracle.com>
 <e525ec74-b62f-6e7c-e6bc-aad93d349f65@gmail.com>
 <54d1140d-3347-a2b1-1b20-9a3959d3b451@oracle.com>
From:   zerons <sironhide0null@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <603ec723-842c-f6e1-01ee-6889c3925a63@gmail.com>
Date:   Wed, 11 Mar 2020 12:48:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <54d1140d-3347-a2b1-1b20-9a3959d3b451@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/20 01:53, santosh.shilimkar@oracle.com wrote:
> On 3/6/20 4:11 AM, zerons wrote:
>>
>>
>> On 2/28/20 02:10, santosh.shilimkar@oracle.com wrote:
>>>
>>>>> On 18 Feb 2020, at 14:13, zerons <sironhide0null@gmail.com> wrote:
>>>>>
>>>>> Hi, all
>>>>>
>>>>> In net/rds/rdma.c
>>>>> (https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/rds/rdma.c?h=v5.5.3*n419__;Iw!!GqivPVa7Brio!OwwQCLtjDsKmhaIz0sfaOVSuC4ai5t5_FgB7yqNExGOCBtACtIGLF61NNJyqSDtIAcGoPg$ ),
>>>>> there may be a race condition between rds_rdma_unuse() and rds_free_mr().
>>>>>
>>> Hmmm.. I didn't see email before in my inbox. Please post questions/patches on netdev in future which is the correct mailing list.
>>>
>>>>> It seems that this one need some specific devices to run test,
>>>>> unfortunately, I don't have any of these.
>>>>> I've already sent two emails to the maintainer for help, no response yet,
>>>>> (the email address may not be in use).
>>>>>
>>>>> 0) in rds_recv_incoming_exthdrs(), it calls rds_rdma_unuse() when receive an
>>>>> extension header with force=0, if the victim mr does not have RDS_RDMA_USE_ONCE
>>>>> flag set, then the mr would stay in the rbtree. Without any lock, it tries to
>>>>> call mr->r_trans->sync_mr().
>>>>>
> MR won't stay in the rbtree with force flag. If the MR is used or
> use_once is set in both cases its removed from the tree.
> See "if (mr->r_use_once || force)"
> 

Sorry, I may misunderstand. Did you mean that if the MR is *used*,
it is removed from the tree with or without the force flag in
rds_rdma_unuse(), even when r_use_once is not set?

Regards,
