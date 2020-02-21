Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA17A166C9A
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 03:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgBUCEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 21:04:15 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42598 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbgBUCEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 21:04:15 -0500
Received: by mail-pg1-f196.google.com with SMTP id w21so177652pgl.9;
        Thu, 20 Feb 2020 18:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wG07xj0gemVpvN5Lxcnyi/UowJtv5uE39R01BYALXNg=;
        b=hELWAMN9u+CA4u8BWfuoMK0nasxUCYWIPrMq5nH93eJ2Id7/Ue7v5LlufRLLufsTV/
         CnqcZ5KYTY8ttPwQgRD8VZW/1JfRN+NxAt6U2MdSJPpK74tbTxKlyt68O6QzEopAT1G5
         +2J+RemYV0SMN5jPz0VUDvL+1wzVWFYkq+T7rLZIEx+AOMUdXUU+0zhSFD4/0Frw3YqS
         iCo77g83ZViejoaOXnwmFXDh33oOPy46+M+Nc3rRFxn3An5KUIm9PriwTgRgEndo5Ef+
         wkI1JI5wHXoGOSjytPXHDDj1u6VsIjFw5xrJwdpus57sHwfG952JBzNmwHj+R/4M2522
         FH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wG07xj0gemVpvN5Lxcnyi/UowJtv5uE39R01BYALXNg=;
        b=ofsX+mzjICIZI2hK7RvXYbs7zl3np+W5SqRcPOI2Izlyicm1kMlQipB4WpgDEXi67k
         vdFrD06Ek4MZKvWegY17kclQHuz16RsUPBBr3i0kPE/EuXUXACCq2CaQRcVOnDlKBsl9
         TAq1K5K3otAPdEZjBZsVEhjIn5y5LLT+91d39gtRORnMxKB9TINpcTqAwIPnrwyxqouG
         Pha27yEelGw0dLs72AgOpBNNeRPseyAOXcqkdZZDMHXJIHj7evy411t1gOTlKxatBwVJ
         hLFYug+lxYQ04vmPOuoMXgy0akLc6bvWmCxlY7JpcY+3Q+fv9ytXbu0W1GIixiqndfZT
         Mw1w==
X-Gm-Message-State: APjAAAVjzTE+mQPJZN67VRpCL3XqbcuBnUJmGwVOhWqU5OZBfTauEG14
        Wbo8UItzlTqz9sHZPLSGJv0=
X-Google-Smtp-Source: APXvYqzIQ2zizyk/l2CjXJ6fyC1yVuUj0QbSwfrbqBovwHJ0GPSdPDRvfg8XFuFoM2IPAF+NHOeJsQ==
X-Received: by 2002:a63:fe43:: with SMTP id x3mr37557621pgj.119.1582250654463;
        Thu, 20 Feb 2020 18:04:14 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::5:f03d])
        by smtp.gmail.com with ESMTPSA id 18sm881639pfj.20.2020.02.20.18.04.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Feb 2020 18:04:13 -0800 (PST)
Date:   Thu, 20 Feb 2020 18:04:11 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix trampoline_count clean up
 logic
Message-ID: <20200221020409.asorthc47wavqlzj@ast-mbp>
References: <20200220230546.769250-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220230546.769250-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 03:05:46PM -0800, Andrii Nakryiko wrote:
> Libbpf's Travis CI tests caught this issue. Ensure bpf_link and bpf_object
> clean up is performed correctly.
> 
> Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines count")
> Cc: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, Thanks
