Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B90F94B89
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfHSRUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:20:32 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35922 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbfHSRUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:20:32 -0400
Received: by mail-qk1-f196.google.com with SMTP id d23so2072050qko.3
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 10:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=TxXXkMQcLj5WD+TfghVnq2XTiHHtaIpH8+XuMB2ywdw=;
        b=KPnEVdnke8LZY6EcQeVACsdeFMfEYrILLwhJONLybj9ZwYGrAcL1m0vqrOaXAwVPBq
         NAWVbnKR1NeKoAyaH3vgTEpm4aueV+++PqSvwJ31/VRTfCb+rh9APeMKGPKOlUvS+N9B
         BmLSSZnN+FS61Tlm16bGQhGBVpMiJvSx79nllCkU98eMLoSRe/pl36nJfvNrnWKXFR7S
         BiQOkeDwVeS+9NWRf8cy05C9hXsgr+tBMtHkZzOvUhMN/oIDElxkRp8I1cGzNrVzJ9Lq
         eW9yjP30KoJ6Y0CxpuOc9XK9yKti1hnuqyw9sxWOJsY3qJli+pIMyLqxMRTX7EokXwui
         FAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=TxXXkMQcLj5WD+TfghVnq2XTiHHtaIpH8+XuMB2ywdw=;
        b=s2xKTRzPcPgKNW/mV6czw0ArogyY7wi636twFGkPCjjjLtQXwxzqdBmS0NhLMTUKQ9
         zjS67Pn2aDzouBaJaSuJqxQsFa72lLI13VozjAvrfDaT0fiyl4+2NpGLQaSXkV+dAINI
         vJZUhjYOOIEKejX/ctjbb1jfeOSNVW8qASdZQ7aCh+PPT1dFUigC1kdRFcaZk/iO7oJ+
         J+M4T7sEHAjFxw/mqMaQx6VK0/ExRm8zi+1iVR+vFuHVT5pX61+NpXDQ9RXFOY8EnNkR
         1rmqseRYDJyumFV+SvqcFv83XUhn+Qyhv+9jfbaSfD3YQ+a41TnDNt45lnYkuMCb0EFS
         4Gdg==
X-Gm-Message-State: APjAAAU3a/4g6iOZW+jWib63y2St1j4RYzg5Q2bLFROSjKThTjP+kyLy
        Glg/ubM7tV5mw91pARsdIxM=
X-Google-Smtp-Source: APXvYqyDVKdH5PIP5hO7jOK4W5jWiiA1F82XT6GeWakxpf6mIECbziBZ+ePyGeXuTrZ6cGBQkRlozQ==
X-Received: by 2002:a05:620a:12d8:: with SMTP id e24mr21901793qkl.416.1566235231113;
        Mon, 19 Aug 2019 10:20:31 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q62sm7777428qkb.69.2019.08.19.10.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 10:20:30 -0700 (PDT)
Date:   Mon, 19 Aug 2019 13:20:29 -0400
Message-ID: <20190819132029.GC26703@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, davem@davemloft.net,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 1/6] net: dsa: use a single switch statement for
 port setup
In-Reply-To: <cb37b6b0-c6c4-6f77-3658-a5cf676fabfe@gmail.com>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
 <20190818173548.19631-2-vivien.didelot@gmail.com>
 <cb37b6b0-c6c4-6f77-3658-a5cf676fabfe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, 19 Aug 2019 10:14:24 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 8/18/19 10:35 AM, Vivien Didelot wrote:
> > It is currently difficult to read the different steps involved in the
> > setup and teardown of ports in the DSA code. Keep it simple with a
> > single switch statement for each port type: UNUSED, CPU, DSA, or USER.
> > 
> > Also no need to call devlink_port_unregister from within dsa_port_setup
> > as this step is inconditionally handled by dsa_port_teardown on error.
> > 
> > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> > ---
> 
> [snip]
> 
> >  	case DSA_PORT_TYPE_CPU:
> > +		memset(dlp, 0, sizeof(*dlp));
> > +		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_CPU,
> > +				       dp->index, false, 0, id, len);
> > +		err = devlink_port_register(dl, dlp, dp->index);
> > +		if (err)
> > +			return err;
> 
> This is shared between all port flavors with the exception that the
> flavor type is different, maybe we should create a helper function and
> factor out even more code. I don't feel great about repeating 3 times t
> the same code without making use of a fall through.

Nah I did not want to use an helper because the code is still too
noodly, if you look at user ports setup, we continue to setup devlink
after the slave creation, so here I prefered to keep things readable
and expose all steps first, before writing yet another helper.


Thanks,

	Vivien
