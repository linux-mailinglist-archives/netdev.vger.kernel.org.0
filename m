Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905F4172A4D
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 22:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgB0Vh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 16:37:28 -0500
Received: from mail-qk1-f169.google.com ([209.85.222.169]:42892 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729726AbgB0Vh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 16:37:28 -0500
Received: by mail-qk1-f169.google.com with SMTP id o28so983958qkj.9
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 13:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u9MU1m+iz8JAHrcyaPeyXeuYCFzczILJ1w8YtSbL4JM=;
        b=YAQh2d+LsAxiqBASmp2Sp2+ivQHQ0jS3c7MKFQHokvkJXS29fNOP5TBOa6bZQnZqOv
         VQJ1VEmAXV5tHwwM8BfDnnpMVtEX0mmFzuuh85h6y11dFhQKfHQ0l1J1wxswosKFCL9o
         l6nyITe91Q5OU/9IPY0kNOtu4G/Ww/Ph1K3M8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u9MU1m+iz8JAHrcyaPeyXeuYCFzczILJ1w8YtSbL4JM=;
        b=SCuMJfbqWSDfEl5pvQZQpU7+1CYw47bpnICF4u5H3CASctsSl5KKVQfEf5TtI2ix5q
         TktssBmy10OE+VDtltpUUo8qb2fy8PXZCCiXNQ3WKK55D+EGeWf/TDJCia3ys5olu5zM
         1bGIxwb53FjCNGZOKagddBJytMuJyuDr2gVLFqiv/xEGEYFVhrLvXOe5R6AQPhUKmZfj
         xIdKSSjaemeTPh+DEVY1BVrL2c2f+pxe2eiPspMI9ul9Ys2NsWuNg4s7qaGPK5Lh9xP4
         oergbGgGk92cij++N9hKapOLs2thna8lT6cYT4m3220N0eAV7Ti65xDdS0RfLz0b78Ul
         fFfw==
X-Gm-Message-State: APjAAAW62UVkoAbY6mMOouW5f0/+jDlXupVythqDO9L3bXYW7MQ+JGzL
        aGsAiPKDMVlQiEXEf5c/acJHXQ==
X-Google-Smtp-Source: APXvYqwQdvyu0bVGafUsE/LzhfnKUsnOBO96G4vT1yFM9D862b6nwrzDN8EXg78FJkLz891qGHGBgg==
X-Received: by 2002:a37:e0d:: with SMTP id 13mr1520845qko.145.1582839447769;
        Thu, 27 Feb 2020 13:37:27 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:a58e:e5e0:4900:6bcd? ([2601:282:803:7700:a58e:e5e0:4900:6bcd])
        by smtp.gmail.com with ESMTPSA id z27sm3834617qtv.11.2020.02.27.13.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 13:37:26 -0800 (PST)
Subject: Re: virtio_net: can change MTU after installing program
To:     Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20200226093330.GA711395@redhat.com> <87lfopznfe.fsf@toke.dk>
 <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com>
 <20200226115258-mutt-send-email-mst@kernel.org>
 <ec1185ac-a2a1-e9d9-c116-ab42483c3b85@digitalocean.com>
 <20200226120142-mutt-send-email-mst@kernel.org>
 <20200226173751.0b078185@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACKFLim6Y5HoUSab=J=ex8hmFbJApivWpXpQV8pnzJ4EBnCs9w@mail.gmail.com>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <7c00848a-51b0-254e-31f7-65fc3741227f@digitalocean.com>
Date:   Thu, 27 Feb 2020 14:37:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CACKFLim6Y5HoUSab=J=ex8hmFbJApivWpXpQV8pnzJ4EBnCs9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/20 12:26 PM, Michael Chan wrote:
> 
> The Broadcom bnxt_en driver should not allow the MTU to be changed to
> an invalid value after an XDP program is attached.  We set the
> netdev->max_mtu to a smaller value and dev_validate_mtu() should
> reject MTUs that are not supported in XDP mode.
> 

That's what I proposed for virtio_net. Simplest option and since max mtu
is now dumped with device details very easy for a user to determine why
a particular MTU fails.
