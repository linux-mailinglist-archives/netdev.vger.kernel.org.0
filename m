Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4C021D8BA
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbgGMOly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729689AbgGMOly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:41:54 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27412C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 07:41:54 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id e90so9712656ote.1
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 07:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tsCDzdm3K+qc+kzyijmDr7EdLOOrftoeyP2MjI1gx3s=;
        b=LGdVosWaZ53uCCUCurOVfq3iCrV5xCk9+TtHRr0REtETNTP0FDA9WcBAeI5BVm/EyW
         cysCDVsP9lQzFca3iNp6de2FuuF3BL5bWe2Zff9CLzhvFUULeM7RphzXySixUsWq7D9e
         DWcj8pyZaar53YzRwyKn3h05biEOcf4EDqe3OlJqXyGnpq6o/3YiymqkVgoY71j7rNGi
         kmwUw0DVgBp5/FrGyWf3ngM0y10gC4IpVwnEyQH9aTSFh7HvaXssiocj/toyeqUVdYuI
         Vx8pjsF7Mpclxziw7xZF1IHbn03wIRy/zo+RIkNm52xXS1BUyV8USqWBwxM9MWTv6LgL
         Xiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tsCDzdm3K+qc+kzyijmDr7EdLOOrftoeyP2MjI1gx3s=;
        b=FFP2dxFrN/tPxmwWDh8VQX+aGXTCcJyJtg7+pQLofkRPY0hLEi7x46e3iazGISy6+h
         Y+vL6HoaXKCK2F+ky7DfIMWWssbVmQEZJ428ZSsB15V0h/Y5n5CMdxp9i+7hgg0CLn38
         h078ouzZgf1D9YpeuJ8h9Xtjii+/oFGLvajNJpJgzMF9wdFzjs6DafFDgx1S9gkzXpwi
         IKZHBvzrpU/rhneWjuLKKX5sUFZIGWlUANoYvIygBXYuzKFtUK639PKR6icSoRhwkfPj
         8MVuPs9dXLHa77yYWzFeSXKDsCLzSZMrq5j6FfrLKT7fgLrXgSdGTWyk0Q73RnwBMLRD
         TU4w==
X-Gm-Message-State: AOAM531XYdkRdj2Lx8COSQ0c1JJfzMaHtwJ9iiLXTd15tJWfoolFJDld
        X7IjV3gtVY27Dn2uvaPFJ84=
X-Google-Smtp-Source: ABdhPJx7C8H+xpw9T4WI5KKBPJSZUKB0rs8hkCQCCGdDOql7MLfEp/eyXdg4nM93zYWdPN2nXplxSA==
X-Received: by 2002:a9d:6654:: with SMTP id q20mr31775399otm.279.1594651313500;
        Mon, 13 Jul 2020 07:41:53 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:a406:dd0d:c1f5:683e? ([2601:284:8202:10b0:a406:dd0d:c1f5:683e])
        by smtp.googlemail.com with ESMTPSA id r25sm3192754oot.38.2020.07.13.07.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 07:41:52 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
To:     Florian Westphal <fw@strlen.de>
Cc:     Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        aconole@redhat.com
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-2-fw@strlen.de> <20200713003813.01f2d5d3@elisabeth>
 <20200713080413.GL32005@breakpoint.cc>
 <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
 <20200713140219.GM32005@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a6821eac-82f8-0d9e-6388-ea6c9f5535d1@gmail.com>
Date:   Mon, 13 Jul 2020 08:41:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200713140219.GM32005@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/20 8:02 AM, Florian Westphal wrote:
> David Ahern <dsahern@gmail.com> wrote:
>> On 7/13/20 2:04 AM, Florian Westphal wrote:
>>>> As PMTU discovery happens, we have a route exception on the lower
>>>> layer for the given path, and we know that VXLAN will use that path,
>>>> so we also know there's no point in having a higher MTU on the VXLAN
>>>> device, it's really the maximum packet size we can use.
>>> No, in the setup that prompted this series the route exception is wrong.
>>
>> Why is the exception wrong and why can't the exception code be fixed to
>> include tunnel headers?
> 
> I don't know.  This occurs in a 3rd party (read: "cloud") environment.
> After some days, tcp connections on the overlay network hang.
> 
> Flushing the route exception in the namespace of the vxlan interface makes
> the traffic flow again, i.e. if the vxlan tunnel would just use the
> physical devices MTU things would be fine.
> 
> I don't know what you mean by 'fix exception code to include tunnel
> headers'.  Can you elaborate?

lwtunnel has lwtunnel_headroom which allows ipv4_mtu to accommodate the
space needed for the encap header. Can something similar be adapted for
the device based tunnels?

> 
> AFAICS everyhing functions as designed, except:
> 1. The route exception should not exist in first place in this case
> 2. The route exception never times out (gets refreshed every time
>    tunnel tries to send a mtu-sized packet).
> 3. The original sender never learns about the pmtu event

meaning the VM / container? ie., this is a VPC using VxLAN in the host
to send packets to another hypervisor. If that is the case why isn't the
underlay MTU bumped to handle the encap header, or the VMs MTU lowered
to handle the encap header? seems like a config problem.
