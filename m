Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43410DA287
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388913AbfJPX66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:58:58 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:44359 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbfJPX66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:58:58 -0400
Received: by mail-lj1-f180.google.com with SMTP id m13so512453ljj.11
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 16:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=syuMJxhb0JoF1Y3jA+QA0ZlyLXzJeuZzeplSZKNpAOc=;
        b=gfMHpSm6zdN0YzoTXHn0vjLyOuMLHqICZ+M7kNawfoUn9tAOXHe4ic+qpKceXb509Z
         vZOSz+Y82OWQEqU3TS8GGfhux6wmgrrlq8GLCTp0NLvaxItFrwdTeHm/A2yCdkCdudUg
         IS5FsZxG8DqPOvfRzg+n3AZvA7tKISQl1q2n8Bgqrc8QVNBWNY18qkivOQquMt4Vl41b
         XeZI2rq8X6aQ+UVc+7f1op+fUfLAe/w7l9pFCN+cOmoMfqg2e1iTYFx52HQr/3AEnYvC
         6GQrUm/3zOTzz9EWhHW8gbn5aLAqQMC2G4k+DRBH3fqms1ircE1wmTPO1BZarsbrNs+X
         87tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=syuMJxhb0JoF1Y3jA+QA0ZlyLXzJeuZzeplSZKNpAOc=;
        b=H38Mvkag0XSxwc5ZGYrLLWX2wR6v9sMef74PLzyPLx7uwHf9vChRNQKQS2BRCddwJk
         IBMKcMAXStc0VJPoQLLLoLtq7mo/mNEvxHtB7phsnTxaEv+B+BLGAX05hoV4duYoQ4yp
         o5vKOwtcUdZM1hnArELJeYRt2/CDjgw2hTNimlqLzggjVIlGXkADWppLJS3g0/Ug9Gvn
         A4+VGApbxunwV1uWn+6CXMh1jCLo5fRKE0OmIDJgqYv/tTZUcYoAKbQbL45kwgCdy+O9
         Lvbr90XZcUHikGlP9HUXfhhhHL8S7oGXnyFDYWrcSerzgMNIpafAFPqKQK/gne53tuVu
         F3zQ==
X-Gm-Message-State: APjAAAVw8UtgCmkMJ7EZqk5LBr2kB0hAuxaE1UT4dXqRrv3pazwCu12d
        ohsPd23QBKj/bskZ/OWOZz/20w==
X-Google-Smtp-Source: APXvYqweMsR3Y0nO/zQvSlAzN+KWoA+uF9AK/Ft8ydPZdjVkP7+59Q5q7k6Aecz9FtFblQXtLBocKw==
X-Received: by 2002:a2e:8593:: with SMTP id b19mr469750lji.34.1571270336020;
        Wed, 16 Oct 2019 16:58:56 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b19sm188820lji.41.2019.10.16.16.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 16:58:55 -0700 (PDT)
Date:   Wed, 16 Oct 2019 16:58:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Lyude Paul <lyude@redhat.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Feng Tang <feng.tang@intel.com>
Subject: Re: [net-next 1/7] igb/igc: Don't warn on fatal read failures when
 the device is removed
Message-ID: <20191016165848.46341167@cakuba.netronome.com>
In-Reply-To: <20191016234711.21823-2-jeffrey.t.kirsher@intel.com>
References: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
        <20191016234711.21823-2-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 16:47:05 -0700, Jeff Kirsher wrote:
> From: Lyude Paul <lyude@redhat.com>
> 
> Fatal read errors are worth warning about, unless of course the device
> was just unplugged from the machine - something that's a rather normal
> occurence when the igb/igc adapter is located on a Thunderbolt dock. So,
> let's only WARN() if there's a fatal read error while the device is
> still present.
> 
> This fixes the following WARN splat that's been appearing whenever I
> unplug my Caldigit TS3 Thunderbolt dock from my laptop:
> 
>  [...]
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 47e16692b26b ("igb/igc: warn when fatal read failure happens")
> Acked-by: Sasha Neftin <sasha.neftin@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Acked-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Any plans to start sending fixes to net? :(
