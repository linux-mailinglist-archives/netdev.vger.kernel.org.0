Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 045D710A7F0
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 02:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfK0B2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 20:28:52 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:35519 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbfK0B2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 20:28:52 -0500
Received: by mail-pg1-f182.google.com with SMTP id l24so1460862pgk.2;
        Tue, 26 Nov 2019 17:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rnzomsGEvWmK6DHLbwnM4g9G/cfdaPXxWaOXimkAyMw=;
        b=ORirqgi30/+MzCdzTdz1sHRwkoZyJXrtDYEyOIwv5DoU+97RLUEWoEUtpqP/bgIT/N
         ksN/K2fpKXwSCvoxaH6jHXjKpgNg9r9kS+m3MP0me8tFxTBTV3vpc4B49+kLN79EDH1E
         D9v6I2f8X7U1wuJLgekiQvOr1l/dQ0XIFdVvQSZ+2YQomGlWxJbByDGpN8VqWYFWdoLZ
         +ooT8ZA1jAtCexlwgpbZZVqHXzFVnVeVlHPj6/Ib8lixxjZFhBQaCP+uJyuqUAn1Skju
         UwQqCDRwabmcwN7WmO08QGlHC8p5mHDouOIMvtiNlosQPzSRUYzhZWYBU2ObuA9L2Fy8
         dJKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rnzomsGEvWmK6DHLbwnM4g9G/cfdaPXxWaOXimkAyMw=;
        b=soZJv40rpTDMs5MBdRZly/2li03JIM2KxydLJklS+8RIxaCVPAVCBjb3Gcj0dZya3k
         cOBwKm3zesiUHkzxcEW8WR1h1+oCOY+WtUpoCKv14w9dHBHQ9E8CMFpSknhgU3gK0H+Y
         sSDDnlrJaQV0LJgcM+wj8VvPJEZUeBAiOYnbnVFSwOxddntm6220Gelaoq0S/ItXC60y
         UdTd6ao0SSAOkboj4Goh+UmnOm64Kh3Ibdse72AUGUQ0eyxNXHMBapg7BFlTJFpVOcMa
         R9G8USlslVx6kzmGlHCtXMFtqdSsmdL2JWnswvxVY3xf9/jdQ8jvVfr7IGuJzg1fHNIz
         X3Qg==
X-Gm-Message-State: APjAAAWxrfy1lqkCqMU9HsF95QsUgz0YtlFMoAm9rnvDUMUz3vffY90f
        X1AoPEj66rrwgTuNOeTKeFc=
X-Google-Smtp-Source: APXvYqzwJd/ZbQ9JW8NIf8L1H0+wP7FB7dlPfL++npvf4Hp+lJvr4lRVhQChVxesWQVbW+25dAlWYg==
X-Received: by 2002:a63:5206:: with SMTP id g6mr1844261pgb.49.1574818131265;
        Tue, 26 Nov 2019 17:28:51 -0800 (PST)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id 125sm14165429pfu.136.2019.11.26.17.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 17:28:50 -0800 (PST)
Subject: Re: [RFC 0/3] Qemu: virtio-net XDP offload
To:     qemu-devel@nongnu.org
Cc:     mst@redhat.com, jasowang@redhat.com, songliubraving@fb.com,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        kvm@vger.kernel.org, yhs@fb.com, andriin@fb.com,
        davem@davemloft.net
References: <157476438124.31055.4199785471534349367@37313f22b938>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <371adc67-33c1-0346-31d7-528057a997ce@gmail.com>
Date:   Wed, 27 Nov 2019 10:27:57 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <157476438124.31055.4199785471534349367@37313f22b938>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/26/19 7:33 PM, no-reply@patchew.org wrote:
> Patchew URL: https://patchew.org/QEMU/20191126100914.5150-1-prashantbhole.linux@gmail.com/
> 
> 
> 
> Hi,
> 
> This series failed the docker-quick@centos7 build test. Please find the testing commands and
> their output below. If you have Docker installed, you can probably reproduce it
> locally.
> 
> === TEST SCRIPT BEGIN ===
> #!/bin/bash
> make docker-image-centos7 V=1 NETWORK=1
> time make docker-test-quick@centos7 SHOW_ENV=1 J=14 NETWORK=1
> === TEST SCRIPT END ===
> 
>    CC      ui/input-keymap.o
>    CC      ui/input-legacy.o
>    CC      ui/kbd-state.o
> /tmp/qemu-test/src/net/tap-linux.c:34:21: fatal error: bpf/bpf.h: No such file or directory
>   #include <bpf/bpf.h>

Sorry, I missed to enclose it in #ifdef CONFIG_LIBBPF.
It should be fixed whenever I'll post next revision.


Prashant


>                       ^
> compilation terminated.
> ---
>    SIGN    pc-bios/optionrom/linuxboot.bin
>    SIGN    pc-bios/optionrom/kvmvapic.bin
>    BUILD   pc-bios/optionrom/linuxboot_dma.img
> make: *** [net/tap-linux.o] Error 1
> make: *** Waiting for unfinished jobs....
>    BUILD   pc-bios/optionrom/pvh.img
>    BUILD   pc-bios/optionrom/linuxboot_dma.raw
> ---
>      raise CalledProcessError(retcode, cmd)
> subprocess.CalledProcessError: Command '['sudo', '-n', 'docker', 'run', '--label', 'com.qemu.instance.uuid=be849bfed02d4ea7b19f7746fe037bd5', '-u', '1001', '--security-opt', 'seccomp=unconfined', '--rm', '-e', 'TARGET_LIST=', '-e', 'EXTRA_CONFIGURE_OPTS=', '-e', 'V=', '-e', 'J=14', '-e', 'DEBUG=', '-e', 'SHOW_ENV=1', '-e', 'CCACHE_DIR=/var/tmp/ccache', '-v', '/home/patchew/.cache/qemu-docker-ccache:/var/tmp/ccache:z', '-v', '/var/tmp/patchew-tester-tmp-3d2z3wl3/src/docker-src.2019-11-26-05.31.05.21708:/var/tmp/qemu:z,ro', 'qemu:centos7', '/var/tmp/qemu/run', 'test-quick']' returned non-zero exit status 2.
> filter=--filter=label=com.qemu.instance.uuid=be849bfed02d4ea7b19f7746fe037bd5
> make[1]: *** [docker-run] Error 1
> make[1]: Leaving directory `/var/tmp/patchew-tester-tmp-3d2z3wl3/src'
> make: *** [docker-run-test-quick@centos7] Error 2
> 
> real    1m56.447s
> user    0m8.519s
> 
> 
> The full log is available at
> http://patchew.org/logs/20191126100914.5150-1-prashantbhole.linux@gmail.com/testing.docker-quick@centos7/?type=message.
> ---
> Email generated automatically by Patchew [https://patchew.org/].
> Please send your feedback to patchew-devel@redhat.com
> 
