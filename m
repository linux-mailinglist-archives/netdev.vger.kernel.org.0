Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66997354ED
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 03:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfFEBQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 21:16:06 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44927 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFEBQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 21:16:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id n2so11396738pgp.11
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 18:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6aS870ho6HU7oGlsp2AtBDHWxTclr6Ov1hUtke4Yr48=;
        b=gch9lAQFymHGg+jNSVr8AEKK63u1ZY12P3HQxMWWnjdZVupLNbV23DEEPlyugWMYaS
         BTxxnMjs8G7vSsvbwVPE/9GAedkwGS8r9oVFVoldHwl79RAxUPrpass9c20CVHLuNgdB
         xDyQy0dasmDb4nVRIUtK5XSexHjXJL/TVrExkOqunVdmsFjA9SKY9UbnX79p+wFreZNa
         auQqeY+uRiSBbiwketd8drQ1YkwjnatxtlizKfO6sn7kmG/jTOfX62fGCM1m5lPkMXUy
         cjzYYEQPT5az324dA40JelpYv2DZDGKBcSA9e142wZMuPa0f5aF7CKlp2Uj9qQ06nVp7
         Cwsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6aS870ho6HU7oGlsp2AtBDHWxTclr6Ov1hUtke4Yr48=;
        b=cv42EukGQcVAjvBbxnt4HVvNfah3rh8M5QvHzpViPYyaWSbbaeplsRG/jBRtKTqe0+
         oMD+MCWhJE6T1NrvDLLsVl05zXXXaeDS/qP8K3LKGWaek2GIDkYm6rezWXMKmWRSP2mQ
         abFR19S8hypnCqWSRlWKxXRK1B5mVviViEuDrk1WlX2uesKGe7zjNMiJe+1o4t0zWFfF
         6ZnytBXczgtJXvk2OSMhiZk7lzfkeGx7s0/4Tp7ou4gv3Y+kI7A3P7su9nFcevQtJnI+
         U6j0l38XyackPLDBuRLtHVjKwECS/SGSxNpPfdOfJsbMFhRmanzxgGD/WqUFA1UATi9M
         EmHg==
X-Gm-Message-State: APjAAAXpsavrkHfJbDIZ8K1oDKVjHEIAOArqyO4aykIL39gVv1Oqm41A
        o9RIIDzy+BwBnhQ35nuQFeI=
X-Google-Smtp-Source: APXvYqyON+WPtiPBX3bkW9AImNiw9qI/TlWsuml6yQto40D+C2Qcx0+zD6NMzK7RIhyg1IDeCE3IMg==
X-Received: by 2002:a63:d949:: with SMTP id e9mr709981pgj.437.1559697364905;
        Tue, 04 Jun 2019 18:16:04 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id i4sm131262pjd.31.2019.06.04.18.16.01
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 18:16:02 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: tcp: enable flowlabel reflection in some RST
 packets
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20190604192942.118949-1-edumazet@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5ce53efb-1a9c-86a8-2b78-e79d670db9bd@gmail.com>
Date:   Tue, 4 Jun 2019 18:16:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190604192942.118949-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/19 12:29 PM, Eric Dumazet wrote:
> This extends commit 22b6722bfa59 ("ipv6: Add sysctl for per
> namespace flow label reflection"), for some TCP RST packets.
> 
> When RST packets are sent because no socket could be found,
> it makes sense to use flowlabel_reflect sysctl to decide
> if a reflection of the flowlabel is requested.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Please wait for a V2, I will use another bit from the sysctl to limit the
risk of regressions.


