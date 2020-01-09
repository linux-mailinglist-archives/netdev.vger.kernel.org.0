Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156AB1355EA
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 10:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgAIJiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 04:38:15 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35836 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729724AbgAIJiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 04:38:14 -0500
Received: by mail-lj1-f195.google.com with SMTP id j1so6498253lja.2
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 01:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gcQepeyN8a6junsMRn+7ni8VGHABXKHWE7W1EIdhZfs=;
        b=owlLCQXLOttB/ajmIM/Pc71l01CpbIpJgFMAPVBrOQkVsK91jbtivfmyySrGcn0l5x
         5DIXsgLprVyhnkPlyij4lEvW0/ZKkpiktqph26M4EJx2nCUkPv3ATPtbKOgXOng8UdUa
         CRg2kEyD+wfiljYgu57wLpw3j+f6fuZv1Js+bNa/VclcH7L4LbaFu2s8XypcfrwEVdWl
         aIZRvQ2fbPM+VJRiT7AZyF4KUwCsLeGI93YiyIVot6/okdT/HyXtJo56De+nsMhW6VWq
         flTesu2g9ezPk8H/BQYN6MEfTRcnx5zVsC+LFjlMAbFebD3vrXNnDncErGD2XhZMknb1
         PjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gcQepeyN8a6junsMRn+7ni8VGHABXKHWE7W1EIdhZfs=;
        b=ILLzkC5K5qaOUDEBi3/eHNOcWKbvZmN1J/tlULfxoyz9x8Yp0N4lRBP2FNwyRkD/5O
         Od5iqiMxEzXxjrN88QC2IbwOfk36mAE2jnt0ay/I1lbMyBjG0PvCtbo10bbBTVt3IZnb
         S7Xhj6wWYg83TiXubmKNccamE8FkRsxSLer3BBrGsg1DGSk7Bbk3kc9xarHgzToLUD1H
         dUyF5+HThe+qTRIIgmyEdNnIDphV4ojSu6APpLV7d+RoWXzsaFM7niZ2c+oEpdrf2w3S
         oS29dJzXjkf9piNo8/BQQvkgm5vMRk/8sspq8e8YT8WSAEUfv0qAJBpagBqhVNVRsgK5
         Sfbg==
X-Gm-Message-State: APjAAAVGk5lU2yJ6Y3ZX+O1NrtzmlJvYHAxaL8yXjcfZVckWtB+CVIB9
        JVLhE//X/YU95o09yulb4YucdWnnPQHjug==
X-Google-Smtp-Source: APXvYqxDJMnX64C1vg8pg4K5D3CklsaMkELPgUFRUawQLQol3vZoCWl9QdvyNDGFoZrt79WRuuzBGg==
X-Received: by 2002:a2e:88c4:: with SMTP id a4mr5761257ljk.174.1578562692487;
        Thu, 09 Jan 2020 01:38:12 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:42d7:1b7d:a8a2:6efa:9cbd:1aee? ([2a00:1fa0:42d7:1b7d:a8a2:6efa:9cbd:1aee])
        by smtp.gmail.com with ESMTPSA id a21sm2779568lfg.44.2020.01.09.01.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 01:38:11 -0800 (PST)
Subject: Re: [PATCH rdma-next 08/10] RDMA/uverbs: Add new relaxed ordering
 memory region access flag
To:     Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org,
        jgg@mellanox.com, dledford@redhat.com
Cc:     saeedm@mellanox.com, maorg@mellanox.com, michaelgur@mellanox.com,
        netdev@vger.kernel.org
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
 <1578506740-22188-9-git-send-email-yishaih@mellanox.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <1a3a3132-67a3-15ba-805f-0eb1c42e78e6@cogentembedded.com>
Date:   Thu, 9 Jan 2020 12:38:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1578506740-22188-9-git-send-email-yishaih@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.01.2020 21:05, Yishai Hadas wrote:

> From: Michael Guralnik <michaelgur@mellanox.com>
> 
> Adding new relaxed ordering access flag for memory regions.
> Using memory regions with relaxed ordeing set can enhance performance.

   Ordering. :-)

> This access flag is handled in a best-effort manner, drivers should
> ignore if they don't support setting relaxed ordering.
> 
> Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
[...]

MBR, Sergei
