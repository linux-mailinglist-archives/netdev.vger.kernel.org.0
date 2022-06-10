Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEEE546A1B
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245457AbiFJQID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbiFJQH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:07:58 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE4F5FC6
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:07:54 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 37-20020a630a25000000b003fdcbe1ffc8so7866404pgk.11
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RI91aW8cZyD67UWTksa3KG7d6VMjCPYeqBCH2eNuiD0=;
        b=IbXs4/WG8QMmH3w3ZThCjgaOXlx8ua5YqnsL2uRqEPItRD2dKYaxmuGTAQc5DuGoOy
         zlpJAhzqc8xl0dtiwOSV/OCTgMHhIO38EBpEkVmiI217Ku1n4v7eXp7yZI9qUHSa//Vz
         u8iGJqIDzZ8e7Zqh180kJ+DCGKkbow6se6eRKIU5i/N7FQdyKqqaaJZmHUMqimLdXJ91
         rfNzWhPZrOBQAwyZDJYrN7DSWSEtH4yPu9LnrnnVmep8/D0KxspfXaqU1Ew26+zYjDU0
         /mnWn0811tMLe3HKSjTwC6j3PMhObv4mWk0YBFv85ilT0Bq1X0ylCnqyUWHFWAyMACb0
         HQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RI91aW8cZyD67UWTksa3KG7d6VMjCPYeqBCH2eNuiD0=;
        b=tWZ5I2aC1XYOWUAPnKMVEGeH/5MHBf9Eb2AofMEA72EpY0iruJefiOP2tyLcGun+Dg
         vwoHx8/TKWzQn54lYfq5DhfqHQ/bV7FlBCCKJSlks2m3tiN/9vPzeMNgwR3aDty3aalz
         +y/xf6OVgCmVd5Zk9wdwvotoE0+Yzf9z9DyMh9fv45lOsRwpZcngjTsvnqNqrhWmaGux
         06zaYWxDHaiIVi4z2OS3w8ysxSUEAJT+kJ5BUk4NejPSSJSTUzxkloziuKjRkxG1jUfa
         bHWznU86PzyoR7SmEY84bV3cdEeANeA0MV4emenCdoDj2DgDGv1/+oKWotiliSeC3eED
         BDzA==
X-Gm-Message-State: AOAM530wfECy1f+1CbTMDwXg9o64l8PXDnyWZeR2qwGSULdB3RaPZSJ2
        PZBSGqPA7woPbxaCtr8tHNDtxBE=
X-Google-Smtp-Source: ABdhPJymzvAlb1/m3wrvUtxNOPXT6DPITNVoP1xrY2Zh4En96XXv2mDz/T1Beiut8R3PjewNDtQv0WQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a62:6407:0:b0:519:3571:903e with SMTP id
 y7-20020a626407000000b005193571903emr51807051pfb.30.1654877273944; Fri, 10
 Jun 2022 09:07:53 -0700 (PDT)
Date:   Fri, 10 Jun 2022 09:07:52 -0700
In-Reply-To: <20220610112648.29695-2-quentin@isovalent.com>
Message-Id: <YqNsWAH24bAIPjqy@google.com>
Mime-Version: 1.0
References: <20220610112648.29695-1-quentin@isovalent.com> <20220610112648.29695-2-quentin@isovalent.com>
Subject: Re: [PATCH bpf-next 1/2] Revert "bpftool: Use libbpf 1.0 API mode
 instead of RLIMIT_MEMLOCK"
From:   sdf@google.com
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/10, Quentin Monnet wrote:
> This reverts commit a777e18f1bcd32528ff5dfd10a6629b655b05eb8.

> In commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of
> RLIMIT_MEMLOCK"), we removed the rlimit bump in bpftool, because the
> kernel has switched to memcg-based memory accounting. Thanks to the
> LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we attempted to keep compatibility
> with other systems and ask libbpf to raise the limit for us if
> necessary.

> How do we know if memcg-based accounting is supported? There is a probe
> in libbpf to check this. But this probe currently relies on the
> availability of a given BPF helper, bpf_ktime_get_coarse_ns(), which
> landed in the same kernel version as the memory accounting change. This
> works in the generic case, but it may fail, for example, if the helper
> function has been backported to an older kernel. This has been observed
> for Google Cloud's Container-Optimized OS (COS), where the helper is
> available but rlimit is still in use. The probe succeeds, the rlimit is
> not raised, and probing features with bpftool, for example, fails.

> A patch was submitted [0] to update this probe in libbpf, based on what
> the cilium/ebpf Go library does [1]. It would lower the soft rlimit to
> 0, attempt to load a BPF object, and reset the rlimit. But it may induce
> some hard-to-debug flakiness if another process starts, or the current
> application is killed, while the rlimit is reduced, and the approach was
> discarded.

> As a workaround to ensure that the rlimit bump does not depend on the
> availability of a given helper, we restore the unconditional rlimit bump
> in bpftool for now.

> [0]  
> https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
> [1] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39

> Cc: Yafang Shao <laoar.shao@gmail.com>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>   tools/bpf/bpftool/common.c     | 8 ++++++++
>   tools/bpf/bpftool/feature.c    | 2 ++
>   tools/bpf/bpftool/main.c       | 6 +++---
>   tools/bpf/bpftool/main.h       | 2 ++
>   tools/bpf/bpftool/map.c        | 2 ++
>   tools/bpf/bpftool/pids.c       | 1 +
>   tools/bpf/bpftool/prog.c       | 3 +++
>   tools/bpf/bpftool/struct_ops.c | 2 ++
>   8 files changed, 23 insertions(+), 3 deletions(-)

> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index a45b42ee8ab0..a0d4acd7c54a 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -17,6 +17,7 @@
>   #include <linux/magic.h>
>   #include <net/if.h>
>   #include <sys/mount.h>
> +#include <sys/resource.h>
>   #include <sys/stat.h>
>   #include <sys/vfs.h>

> @@ -72,6 +73,13 @@ static bool is_bpffs(char *path)
>   	return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
>   }

> +void set_max_rlimit(void)
> +{
> +	struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
> +
> +	setrlimit(RLIMIT_MEMLOCK, &rinf);

Do you think it might make sense to print to stderr some warning if
we actually happen to adjust this limit?

if (getrlimit(MEMLOCK) != RLIM_INFINITY) {
	fprintf(stderr, "Warning: resetting MEMLOCK rlimit to
	infinity!\n");
	setrlimit(RLIMIT_MEMLOCK, &rinf);
}

?

Because while it's nice that we automatically do this, this might still
lead to surprises for some users. OTOH, not sure whether people
actually read those warnings? :-/

> +}
> +
>   static int
>   mnt_fs(const char *target, const char *type, char *buff, size_t bufflen)
>   {
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index cc9e4df8c58e..bac4ef428a02 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -1167,6 +1167,8 @@ static int do_probe(int argc, char **argv)
>   	__u32 ifindex = 0;
>   	char *ifname;

> +	set_max_rlimit();
> +
>   	while (argc) {
>   		if (is_prefix(*argv, "kernel")) {
>   			if (target != COMPONENT_UNSPEC) {
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 9062ef2b8767..e81227761f5d 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -507,9 +507,9 @@ int main(int argc, char **argv)
>   		 * It will still be rejected if users use LIBBPF_STRICT_ALL
>   		 * mode for loading generated skeleton.
>   		 */
> -		libbpf_set_strict_mode(LIBBPF_STRICT_ALL &  
> ~LIBBPF_STRICT_MAP_DEFINITIONS);
> -	} else {
> -		libbpf_set_strict_mode(LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK);
> +		ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL &  
> ~LIBBPF_STRICT_MAP_DEFINITIONS);
> +		if (ret)
> +			p_err("failed to enable libbpf strict mode: %d", ret);
>   	}

>   	argc -= optind;
> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
> index 6c311f47147e..589cb76b227a 100644
> --- a/tools/bpf/bpftool/main.h
> +++ b/tools/bpf/bpftool/main.h
> @@ -96,6 +96,8 @@ int detect_common_prefix(const char *arg, ...);
>   void fprint_hex(FILE *f, void *arg, unsigned int n, const char *sep);
>   void usage(void) __noreturn;

> +void set_max_rlimit(void);
> +
>   int mount_tracefs(const char *target);

>   struct obj_ref {
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index 800834be1bcb..38b6bc9c26c3 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -1326,6 +1326,8 @@ static int do_create(int argc, char **argv)
>   		goto exit;
>   	}

> +	set_max_rlimit();
> +
>   	fd = bpf_map_create(map_type, map_name, key_size, value_size,  
> max_entries, &attr);
>   	if (fd < 0) {
>   		p_err("map create failed: %s", strerror(errno));
> diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
> index e2d00d3cd868..bb6c969a114a 100644
> --- a/tools/bpf/bpftool/pids.c
> +++ b/tools/bpf/bpftool/pids.c
> @@ -108,6 +108,7 @@ int build_obj_refs_table(struct hashmap **map, enum  
> bpf_obj_type type)
>   		p_err("failed to create hashmap for PID references");
>   		return -1;
>   	}
> +	set_max_rlimit();

>   	skel = pid_iter_bpf__open();
>   	if (!skel) {
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index e71f0b2da50b..f081de398b60 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1590,6 +1590,8 @@ static int load_with_options(int argc, char **argv,  
> bool first_prog_only)
>   		}
>   	}

> +	set_max_rlimit();
> +
>   	if (verifier_logs)
>   		/* log_level1 + log_level2 + stats, but not stable UAPI */
>   		open_opts.kernel_log_level = 1 + 2 + 4;
> @@ -2287,6 +2289,7 @@ static int do_profile(int argc, char **argv)
>   		}
>   	}

> +	set_max_rlimit();
>   	err = profiler_bpf__load(profile_obj);
>   	if (err) {
>   		p_err("failed to load profile_obj");
> diff --git a/tools/bpf/bpftool/struct_ops.c  
> b/tools/bpf/bpftool/struct_ops.c
> index 2535f079ed67..e08a6ff2866c 100644
> --- a/tools/bpf/bpftool/struct_ops.c
> +++ b/tools/bpf/bpftool/struct_ops.c
> @@ -501,6 +501,8 @@ static int do_register(int argc, char **argv)
>   	if (libbpf_get_error(obj))
>   		return -1;

> +	set_max_rlimit();
> +
>   	if (bpf_object__load(obj)) {
>   		bpf_object__close(obj);
>   		return -1;
> --
> 2.34.1

