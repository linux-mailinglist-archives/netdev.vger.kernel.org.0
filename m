Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96777A3FB3
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbfH3Vg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:36:27 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36519 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfH3Vg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:36:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so4164888pgm.3
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=76QdysOCmSp1PnJcg6eWwiopf2Dn3FgfjCclb+CUVIY=;
        b=l30cE2wnx/r7Gg9fc1odfzKenwtsnNSsfRUJHaRUV5KUeskkexZNrvQJw8u5APcPU9
         ldWaE07UPe0gARrkXHd272PWE19QhZhsrNjD1hXFnplSWK+IYsONf1c2y1W+biGafWrq
         5jSSLO/IjADkKrR9ueuwHhc8CqY+wVl4E/JPYDjEsH57wv0x3oawDLggT/KqtS8RMaFZ
         0Sdz26SzrBy1+DLndVgQ/2PZVBJRMjbLy1zcyOPXEJAHYqxKhPilOvT1G//oprXQfx6o
         QNVmhGabgsTWIQIhYjlmb6MY1rQ2SInqO4WpdebiDm7gMrFk1hkGDabu95GZsnQIg6jm
         ecIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=76QdysOCmSp1PnJcg6eWwiopf2Dn3FgfjCclb+CUVIY=;
        b=ngDDPAC5KXJAFNJtbsZWhgNZPjkfDFRKbdjmGbylNtDDgfSFKWV6eK3zS5qsv93J4k
         AWJu89u5e3BmRDcD8ZQSo5WmBONou9OKp4bMfZPIA1E8R5ntID9RHEy4QjA2oZhKXvY/
         yOZHcCfX14qDDASeYKewq3zXQVeGcfwp/xnnSaLyeY9vLTb+jNMi46ZZdHtfBKT+/f09
         oLeo0W4lTgDhppEGiPAj3VZqEkzyssXNhLGd4KmuvQbBxBFW5iBYlqkhJeo3oazOg3R0
         FUJq/Jo6Mqxsj/ApalIav2I5L8+4cPh6pWNoyz3Eabb8fRIlsCyTcAevQjZ4prN3xDtT
         AaEA==
X-Gm-Message-State: APjAAAWrnjgcS6fcOgecFaubQYU14n6AQDlr8Y6qTvLXD3PVdvUifp9b
        mCOyLY/tasAmzsOdKOy+5JhPY7Usnmg=
X-Google-Smtp-Source: APXvYqw7EvMvd5N0pJ29yPqps8xU8Qf4i1WkrZpUn4oXqxoHjIcLJLNaXkXzeLgN+qq3AAT6Wcl9bw==
X-Received: by 2002:a17:90a:6504:: with SMTP id i4mr622843pjj.13.1567200986584;
        Fri, 30 Aug 2019 14:36:26 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id q2sm4822315pfg.144.2019.08.30.14.36.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 14:36:25 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 16/19] ionic: Add netdev-event handling
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190829182720.68419-1-snelson@pensando.io>
 <20190829182720.68419-17-snelson@pensando.io>
 <20190829163738.64e7fe42@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <336eacda-27ae-d513-7888-429e34e29b76@pensando.io>
Date:   Fri, 30 Aug 2019 14:36:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829163738.64e7fe42@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 4:37 PM, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 11:27:17 -0700, Shannon Nelson wrote:
>> When the netdev gets a new name from userland, pass that name
>> down to the NIC for internal tracking.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> There is a precedent in ACPI for telling the FW what OS is running but
> how is the interface name useful for the firmware I can't really tell.
It is so we can correlate the host's interface name with the internal 
port data for internal logging.

sln

