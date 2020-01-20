Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D161430E5
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 18:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgATRjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 12:39:35 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33566 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATRjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 12:39:35 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so41155pgk.0
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 09:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rESkrE6wbtqjBlbhD/0AjEwSR4uvpy8zo9mhbakE6ZM=;
        b=F6OA/sOhav3s28PIqcmCAuQEp0Y6pqSsbfTHVS9Z1MGaBrQfTCAlKfj9MGsnOvX4qY
         +Sb8hAGhFSqOv9HBs6bcleKCpBGtkgnxcM+hNZL1jhBSOIBiDEBr/HuAlYsczr/2tZU8
         OZpvKhFIbY5PQ0pF+asojEDlVzmdvvNVDGoy0/Xih75kxCXq9RTjVJb1lyicOLMvlLaM
         Du2OxOeg10TB19TolMvzrLut/LBjWY9LUuNWTg7jeDuYRYURKZR3HqCM4/iMzeeYjB/X
         neoZLQfvexu+SMFN5cV/StrPkkj05cJ5B63m5EevPTXqY0BCYs1rV9jkR3gzrdx60GFo
         uZxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rESkrE6wbtqjBlbhD/0AjEwSR4uvpy8zo9mhbakE6ZM=;
        b=E/vfVFBVv0JXxZVSSBOZ9EqaMYlrS+K4b6/t8WsoHgvJ7CAArGyyuIs+f+LunsTk6X
         ZuK3KBlTtcK87ecCtePOADhCGx6sGgoCqA5Klnvv5/OCxQcnpScst0Fk7FcfV9iamsfC
         yC5F/SA9q7ndly5e0+vBvqGRonqVgVt5crEDCY7ExmvCoVG2gX6NHeFfE7LilaPPgkSn
         +gEhOT8U4JAm13rGQU5Wafuqkj8O3H/udizEfM+RHxXH3MzPLOGmaOpyk0Oo4asT9cLH
         s3NG4ItdiwW3XWXDNWbxTMVV2BhKZeaO3R5j+6Zv/0c0nvVc5+3hQTuToAqlCI74sQzY
         yFbw==
X-Gm-Message-State: APjAAAV8ieFydU/S2jMJ0VHnWk0Esd2wv6Jp73GQuULPgJLtRXOcutIq
        Q48SVq1lSmW+z+Q74ZqQ+ctWAA==
X-Google-Smtp-Source: APXvYqxReTsDCHn6G1vcLRFXDNg1pD4UuA2Jb13gHZ+XuN6zZPuFOEwRlxt+cZVVE+Sbpq45qyprIA==
X-Received: by 2002:aa7:9edd:: with SMTP id r29mr311046pfq.14.1579541974334;
        Mon, 20 Jan 2020 09:39:34 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d1sm95101pjx.6.2020.01.20.09.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 09:39:34 -0800 (PST)
Date:   Mon, 20 Jan 2020 09:39:26 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2] tc: flower: fix print with oneline option
Message-ID: <20200120093926.1bf3ce01@hermes.lan>
In-Reply-To: <20200107092210.1562-1-roid@mellanox.com>
References: <20200107092210.1562-1-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Jan 2020 11:22:10 +0200
Roi Dayan <roid@mellanox.com> wrote:

> This commit fix all location in flower to use _SL_ instead of \n for
> newline to allow support for oneline option.
> 
> Example before this commit:
> 
> filter protocol ip pref 2 flower chain 0 handle 0x1
>   indev ens1f0
>   dst_mac 11:22:33:44:55:66
>   eth_type ipv4
>   ip_proto tcp
>   src_ip 2.2.2.2
>   src_port 99
>   dst_port 1-10\  tcp_flags 0x5/5
>   ip_flags frag
>   ct_state -trk\  ct_zone 4\  ct_mark 255
>   ct_label 00000000000000000000000000000000
>   skip_hw
>   not_in_hw\    action order 1: ct zone 5 pipe
>          index 1 ref 1 bind 1 installed 287 sec used 287 sec
>         Action statistics:\     Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0\
> 
> Example output after this commit:
> 
> filter protocol ip pref 2 flower chain 0 handle 0x1 \  indev ens1f0\  dst_mac 11:22:33:44:55:66\  eth_type ipv4\  ip_proto tcp\  src_ip 2.2.2.2\  src_port 99\  dst_port 1-10\  tcp_flags 0x5/5\  ip_flags frag\  ct_state -trk\  ct_zone 4\  ct_mark 255\  ct_label 00000000000000000000000000000000\  skip_hw\  not_in_hw\action order 1: ct zone 5 pipe
>          index 1 ref 1 bind 1 installed 346 sec used 346 sec
>         Action statistics:\     Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0\
> 
> Signed-off-by: Roi Dayan <roid@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

In general this is fine. A couple of small style issues.
You may have noticed that iproute2 uses kernel formatting style.
Therefore checkpatch is useful tool to look for these.

ERROR: space required after that ',' (ctx:VxV)
#187: FILE: tc/f_flower.c:1898:q
+	sprintf(namefrm,"  %s %%u", name);
 	               ^

ERROR: else should follow close brace '}'
#326: FILE: tc/f_flower.c:2295:
 		}
+		else if (flags & TCA_CLS_FLAGS_NOT_IN_HW) {


ERROR: space required after that ',' (ctx:VxV)
#187: FILE: tc/f_flower.c:1898:
+	sprintf(namefrm,"  %s %%u", name);
 	               ^

ERROR: else should follow close brace '}'
#326: FILE: tc/f_flower.c:2295:
 		}
+		else if (flags & TCA_CLS_FLAGS_NOT_IN_HW) {
