Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDCEEF3A0
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 03:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfKECqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 21:46:00 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44300 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729830AbfKECp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 21:45:59 -0500
Received: by mail-lj1-f193.google.com with SMTP id g3so13842753ljl.11
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 18:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+FDcCstIIOjapCXSv7mnuJ/rUCWrh35Neal7kZlmcF4=;
        b=KN8/Wp7lwFy1gLJn5CO2zmPNm3BlLtANbvaQUUxggSaDRgwjyuy0wmyFq5W7RlWU15
         LbQt0jJNwzaM3pmDeQtxG/tqSXGsN9hnxoQtzd1N+Dk3u5U9DqaLg5esMep6PDoids7f
         aGVuwHzJKMZGr/0Ci3xXjoQM7Uz7Y/tDArKas66pASS/HOhvh+7P/LzDr7XZ7H/u9fA+
         dFLB2GlJbg/q48PzTZ3QhMR8OrEMFyIvK8qkj8beVCG6mWv7tcvW7U943HQMEoJLl8TJ
         9u0iLTu410tA/m8CLlkeZt3z1fY8ccPC1nXAVrlVUgAMP85R/ugVeKAyi4rgTuDHkkQy
         SpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+FDcCstIIOjapCXSv7mnuJ/rUCWrh35Neal7kZlmcF4=;
        b=AuO0w6hueycu5TdBnpAcmr6dAAILVNR4l/EfHyoEJ3jv5IEIZCE8CMcMQwRcT9E1Lh
         Qu7ECxB7SgCMCAnWJs0wfJq50vXwbsRCe9EXr+fd36MNTEoc2W6V9UaATU5sQ346rznC
         trUaLmdHiYBgbioNsCbDz93+ZGd2xNtmlu4PQvRsqW0C9NDwOGIPkik+E6lUsJdxJy0z
         60Az2VOLNPD2tZlXeUHE6i55gJQj/EWRZ6sZxUGD/ZZdh6R4wiZG+WYaYkjXnwDau/P4
         QgVLG15VGHqhUaqNnqZ1cQ9qRJrDhIf/Vp+O0Q53B6MxHY6LARf7/W9sOiuExqvK7+OJ
         DaWw==
X-Gm-Message-State: APjAAAXAlwxoIXbXNbGC2qW9lxmS2yPUTV/WO6p8+4VQQI49WseDi1W7
        +8gAK5j+s76FA80klw5fAWyli4jrcEA=
X-Google-Smtp-Source: APXvYqyCxT/6jRcd03iBSSQ85tFktytduN9L7wK/LczLithZ8tHu/nnaqTY/EkrLFKp9bR05sH+nMA==
X-Received: by 2002:a2e:8e21:: with SMTP id r1mr21231510ljk.81.1572921957654;
        Mon, 04 Nov 2019 18:45:57 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 68sm5065655ljf.26.2019.11.04.18.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 18:45:57 -0800 (PST)
Date:   Mon, 4 Nov 2019 18:45:50 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next] bpf: re-fix skip write only files in debugfs
Message-ID: <20191104184550.73e839f8@cakuba.netronome.com>
In-Reply-To: <94ba2eebd8d6c48ca6da8626c9fa37f186d15f92.1572876157.git.daniel@iogearbox.net>
References: <94ba2eebd8d6c48ca6da8626c9fa37f186d15f92.1572876157.git.daniel@iogearbox.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Nov 2019 15:27:02 +0100, Daniel Borkmann wrote:
>  [
>    Hey Jakub, please take a look at the below merge fix ... still trying
>    to figure out why the netdev doesn't appear on my test node when I
>    wanted to run the test script, but seems independent of the fix.
> 
>    [...]
>    [ 1901.270493] netdevsim: probe of netdevsim4 failed with error -17
>    [...]
> 
>    # ./test_offload.py
>    Test destruction of generic XDP...
>    Traceback (most recent call last):
>     File "./test_offload.py", line 800, in <module>
>      simdev = NetdevSimDev()
>     File "./test_offload.py", line 355, in __init__
>      self.wait_for_netdevs(port_count)
>     File "./test_offload.py", line 390, in wait_for_netdevs
>      raise Exception("netdevices did not appear within timeout")
>    Exception: netdevices did not appear within timeout
>  ]

I got this fixed, looks like the merged also added back some duplicated
code, surreptitiously.

I'm still debugging another issue with the devlink.sh test which looks
broken.
