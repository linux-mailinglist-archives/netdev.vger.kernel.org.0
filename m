Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6822DC3D7
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgLPQPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgLPQPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:15:51 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6118C06179C;
        Wed, 16 Dec 2020 08:15:10 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id k7so5331566ooa.0;
        Wed, 16 Dec 2020 08:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6RZ2/RFYYKW7wg5EsRKIjcmmRjL7D4DszmVpsA9M4oY=;
        b=PE0DaspM4nUjHtompvyGvi3pY370RVUm8NM2cOIkaSy9ZrwYw2EpRO1KG+uidyi8Uz
         OOhFbbsw2Ur0S0qrh+5u4n2Wo3qYCmyEL1oDHSZai+XaeGowUXJG5gqsF+80UEg+TVcz
         NDP+8aDk1iMyzkPGGYPuLgXlqIe8MvcIK9mmI+2ncbxobjliatluWeybwNX1nl8Nv7QU
         Cz7Gyjdvp4oNURuh3biLinin75ShTpQNg9HpSJHYeyHn05Lj/F7DKnO1RcRUyKniWrhW
         qUS/fMFIpkhSUGvOCAAeEPffEusxgXAKibQL9S52THg95m9OiZxLiVlTjCdxljRWChwQ
         qXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6RZ2/RFYYKW7wg5EsRKIjcmmRjL7D4DszmVpsA9M4oY=;
        b=BChCkz861bwv+lBn69G1+blzZsmWLjDf0cC+ippHci7kPvGMMKI1NzcpjA6Mb0Lse4
         5zcEKsAq089nLEHWEMvMhXqUP1vVT9d9AUt4GZ7o5XWXOpSDH/qK+Koobpg4mN/B1iHw
         cC43GIL28z7xe7dFSQkhqe0HBysmpKWT+zfs4ccFc1jRuKXCWDbULXPPBJBpwWNnDBOC
         U95SM5Jk5IibuUjZjVlfPFWdjsE2chNLviMqZU0gawE/doE9rkzb7lwmEUAqRyWWm/ol
         NNTstVVUfPdfZmR6UYDqWZtT+5HbO+29/hZ7b0tkwYmZV8aLY+uiK0ybTnZPK6SibNEC
         KHhA==
X-Gm-Message-State: AOAM532MfEjUjbKmQYSKsfCDbOR4RcIQdU2wrW8n8NppBllAGXnvTswI
        AeIp3aKou9xQFbrbw2MHdsI=
X-Google-Smtp-Source: ABdhPJw+LOVZLktiRRZkz5ckP6695O6NONOSOw6mcr3AxLjTyyAzjtxfjuX8eOxyhJmIGs3rgiFtjQ==
X-Received: by 2002:a4a:9c5:: with SMTP id 188mr16823341ooa.77.1608135310169;
        Wed, 16 Dec 2020 08:15:10 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:135:8f2e:367:a2c2])
        by smtp.googlemail.com with ESMTPSA id i82sm482935oia.2.2020.12.16.08.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 08:15:09 -0800 (PST)
Subject: Re: [net-next v5 05/15] devlink: Support get and set state of port
 function
To:     Parav Pandit <parav@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20201215090358.240365-1-saeed@kernel.org>
 <20201215090358.240365-6-saeed@kernel.org>
 <20201215163747.4091ff61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43225346806029AA31D63918DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9eeff74c-fb7f-a24d-de1e-34e32428d83c@gmail.com>
Date:   Wed, 16 Dec 2020 09:15:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43225346806029AA31D63918DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/20 10:15 PM, Parav Pandit wrote:
>>> + * enum devlink_port_function_opstate - indicates operational state
>>> + of port function
>>> + * @DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED: Driver is attached
>> to the
>>> + function of port,
>> This name definitely needs to be shortened.
>>
> DEVLINK_PORT_FUNCTION_OPS_ATTACHED
> Or
> DEVLINK_PF_OPS_ATTACHED 
> 
> PF - port function
>  

The devlink attribute names need to start using established short names
to find that balance between readability and ridiculously long names.

In this case PF for networking has an established link to SRIOV
'physical function'.

FUNCTION can be written as FCN.
ATTACHED can be shortened to ATTCH.

So in this case DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED (38 chars) drops
to DEVLINK_PORT_FCN_OPSTATE_ATTCH (30 chars). That is a step in the
right direction.



