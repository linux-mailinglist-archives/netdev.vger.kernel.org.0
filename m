Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E2D1094DC
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 21:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfKYUxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 15:53:33 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40736 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfKYUxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 15:53:32 -0500
Received: by mail-qk1-f194.google.com with SMTP id a137so12305441qkc.7
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 12:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JI4R2Exiz2zUPjmAEcLAdnWuq7egECrOmXRPWhAIU2w=;
        b=BpvqRwg9XBca1hNN7pDbp27pL81dMK9xtBOcXm/vPGxqD6njAqZ8aiIqFin3XNKzVh
         CijhJ6n03b70X3wC9oeNjz4wmXwMju23h3yzVFwMQq3JKL1+X2HkVqEc056x3Zp8Qp3v
         GHHgkwgkSt9JDlIZNP2nbM2F48fbUL9qufTl6PPV7aevpB++GSZLOq647pIXqLGioFPs
         owfjVByvX1riDXNu2jwDBVIhg4o+1SvTZxGFd0rSmmtnot+qpq/6rwLfiWESnW32zts/
         57NcbkWZo5zncPCiafiLVbRoZ1pqo6W9i25DsO0m8E0lOGC5KuQ2gANsP2WWVCKQV1lP
         CNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JI4R2Exiz2zUPjmAEcLAdnWuq7egECrOmXRPWhAIU2w=;
        b=bwr9AvFQobvWyUMilaO51JpkFXmhlaupxGkxXJMMjYd+41sb9BQkoTwniki5GN7Z9d
         y44l5/gV86Su9Jy6QXB6I34ZsWvbwnvCoiCd1unPn4Qdm90x9GTE3Qhu7xq/vaPw2fSr
         qoC5A7w8cjOciTOqCgHqNoUg7Jnj3/7CKNl9OLkMBPn7RaQbFBm9WLeAGrcVogCQDG36
         iO11Yd613zKXLG9XJbdbr/ZzMVHFr/Wmk3RUGkxZiqmD7pYKRnZBRDb70DKVpJpIeYL7
         m555lBpF1Nfq3A+8sGq70gLMErZfIHAktr4QCmIrcLcfaTTfGZYnN/HBUN2K48l0AWPk
         NYWw==
X-Gm-Message-State: APjAAAU8WKW4SGusXQAsAe33OVTjhhfLzhGQ00TM/PLRhpu8ID4WnlL1
        0HqSj5oD1GX6dupftCQK1ON1MCb6
X-Google-Smtp-Source: APXvYqwZyeoZQeVPSAsUlkDSxOvouim0AgZl15ofGjezZO5e37K02EG0KT4r2EDrl90TQcmjeMwRjw==
X-Received: by 2002:a05:620a:1319:: with SMTP id o25mr19387574qkj.83.1574715211462;
        Mon, 25 Nov 2019 12:53:31 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:c06f:8df5:46f1:d3e5])
        by smtp.googlemail.com with ESMTPSA id k7sm3975236qkf.40.2019.11.25.12.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 12:53:30 -0800 (PST)
Subject: Re: VRF and/or cgroups problem on Fedora-30, 5.2.21+ kernel
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com>
 <850a6d4e-3a67-a389-04a0-87032e0683d8@gmail.com>
 <213aa1d3-5df9-0337-c583-34f3de5f1582@candelatech.com>
 <8ae551e1-5c2e-6a95-b4d1-3301c5173171@gmail.com>
 <ffbeb74f-09d5-e854-190e-5362cc703a10@candelatech.com>
 <fb74534d-f5e8-7b9b-b8c0-b6d6e718a275@gmail.com>
 <3daeee00-317a-1f82-648e-80ec14cfed22@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b64cb1b5-f9be-27ab-76e8-4fe84b947114@gmail.com>
Date:   Mon, 25 Nov 2019 13:53:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3daeee00-317a-1f82-648e-80ec14cfed22@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/19 10:35 AM, Ben Greear wrote:
>>> And surely 'ip' could output a better error than just 'permission
>>> denied' for
>>> this error case?  Or even something that would show up in dmesg to give
>>> a clue?
>>
>> That error comes from the bpf syscall:
>>
>> bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_CGROUP_SOCK, insn_cnt=6,
>> insns=0x7ffc8e5d1e00, license="GPL", log_level=1, log_size=262144,
>> log_buf="", kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0,
>> prog_name="", prog_ifindex=0,
>> expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0,
>> func_info_rec_size=0, func_info=NULL, func_info_cnt=0,
>> line_info_rec_size=0, line_info=NULL, line_info_cnt=0}, 112) = -1 EPERM
>> (Operation not permitted)
> 
> So, we can change iproute/lib/bpf.c to print a suggestion to increase
> locked memory
> if this returns EPERM?
> 

looks like SYS_ADMIN and locked memory are the -EPERM failures.

I do not see any API that returns user->locked_vm, only per-task
locked_vm. Knowing that number would help a lot in understanding proper
system settings.

Running 'perf record' while trying to do 'ip vrf exec' is an easy way to
hit the locked memory exceeded error. We could add a hint to iproute2.
Something like:

diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index b9a43675cbd6..15637924f31a 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -281,9 +281,16 @@ static int vrf_configure_cgroup(const char *path,
int ifindex)
                fprintf(stderr, "Failed to load BPF prog: '%s'\n",
                        strerror(errno));

-               if (errno != EPERM) {
+               if (errno == EPERM) {
+                       if (geteuid() != 0)
+                               fprintf(stderr,
+                                       "Hint: Must run as root to set
VRF.\n");
+                       else
+                               fprintf(stderr,
+                                       "Hint: Most likely locked memory
threshold exceeded. Increase 'ulimit -l'\n");
+               } else {
                        fprintf(stderr,
-                               "Kernel compiled with CGROUP_BPF
enabled?\n");
+                               "Hint: Kernel compiled with CGROUP_BPF
enabled?\n");
                }
                goto out;
        }

