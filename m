Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101F62313ED
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgG1U3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:29:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38623 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbgG1U3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:29:44 -0400
Received: from static-50-53-54-182.bvtn.or.frontiernet.net ([50.53.54.182] helo=[192.168.192.153])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <john.johansen@canonical.com>)
        id 1k0WEE-0004uy-Qi; Tue, 28 Jul 2020 20:29:39 +0000
Subject: Re: [PATCH v19 15/23] LSM: Use lsmcontext in security_secid_to_secctx
To:     Casey Schaufler <casey@schaufler-ca.com>,
        casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     linux-audit@redhat.com, keescook@chromium.org,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, netdev@vger.kernel.org
References: <20200724203226.16374-1-casey@schaufler-ca.com>
 <20200724203226.16374-16-casey@schaufler-ca.com>
From:   John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; prefer-encrypt=mutual; keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUlOQkU1bXJQb0JFQURB
 azE5UHNnVmdCS2tJbW1SMmlzUFE2bzdLSmhUVEtqSmR3VmJrV1NuTm4rbzZVcDVrCm5LUDFm
 NDlFQlFsY2VXZzF5cC9Od2JSOGFkK2VTRU8vdW1hL0srUHFXdkJwdEtDOVNXRDk3Rkc0dUI0
 L2Nhb20KTEVVOTdzTFFNdG52R1dkeHJ4VlJHTTRhbnpXWU1neno1VFptSWlWVFo0M091NVZw
 YVMxVnoxWlN4UDNoL3hLTgpaci9UY1c1V1FhaTh1M1BXVm5ia2poU1pQSHYxQmdoTjY5cXhF
 UG9tckpCbTFnbXR4M1ppVm1GWGx1d1RtVGdKCk9rcEZvbDduYkowaWxuWUhyQTdTWDNDdFIx
 dXBlVXBNYS9XSWFuVk85NldkVGpISElhNDNmYmhtUXViZTR0eFMKM0ZjUUxPSlZxUXN4NmxF
 OUI3cUFwcG05aFExMHFQV3dkZlB5LyswVzZBV3ROdTVBU2lHVkNJbld6bDJIQnFZZAovWmxs
 OTN6VXErTklvQ244c0RBTTlpSCt3dGFHRGNKeXdJR0luK2VkS050SzcyQU1nQ2hUZy9qMVpv
 V0g2WmVXClBqdVVmdWJWelp0bzFGTW9HSi9TRjRNbWRRRzFpUU50ZjRzRlpiRWdYdXk5Y0dp
 MmJvbUYwenZ5QkpTQU5weGwKS05CRFlLek42S3owOUhVQWtqbEZNTmdvbUwvY2pxZ0FCdEF4
 NTlMK2RWSVpmYUYyODFwSWNVWnp3dmg1K0pvRwplT1c1dUJTTWJFN0wzOG5zem9veWtJSjVY
 ckFjaGtKeE5mejdrK0ZuUWVLRWtOekVkMkxXYzNRRjRCUVpZUlQ2ClBISGdhM1JneWtXNSsx
 d1RNcUpJTGRtdGFQYlhyRjNGdm5WMExSUGN2NHhLeDdCM2ZHbTd5Z2Rvb3dBUkFRQUIKdEIx
 S2IyaHVJRXB2YUdGdWMyVnVJRHhxYjJodVFHcHFiWGd1Ym1WMFBva0NPZ1FUQVFvQUpBSWJB
 d1VMQ1FnSApBd1VWQ2drSUN3VVdBZ01CQUFJZUFRSVhnQVVDVG8wWVZ3SVpBUUFLQ1JBRkx6
 WndHTlhEMkx4SkQvOVRKWkNwCndsbmNUZ1llcmFFTWVEZmtXdjhjMUlzTTFqMEFtRTRWdEwr
 ZkU3ODBaVlA5Z2tqZ2tkWVN4dDdlY0VUUFRLTWEKWlNpc3JsMVJ3cVUwb29nWGRYUVNweHJH
 SDAxaWN1LzJuMGpjWVNxWUtnZ1B4eTc4QkdzMkxacTRYUGZKVFptSApaR25YR3EvZURyL21T
 bmowYWF2QkptTVo2amJpUHo2eUh0QllQWjlmZG84YnRjendQNDFZZVdvSXUyNi84SUk2CmYw
 WG0zVkM1b0FhOHY3UmQrUldaYThUTXdsaHpIRXh4ZWwzanRJN0l6ek9zbm1FOS84RG0wQVJE
 NWlUTENYd1IKMWN3SS9KOUJGL1MxWHY4UE4xaHVUM0l0Q05kYXRncDh6cW9Ka2dQVmptdnlM
 NjRRM2ZFa1liZkhPV3NhYmE5LwprQVZ0Qk56OVJURmg3SUhEZkVDVmFUb3VqQmQ3QnRQcXIr
 cUlqV0ZhZEpEM0k1ZUxDVkp2VnJyb2xyQ0FUbEZ0Ck4zWWtRczZKbjFBaUlWSVUzYkhSOEdq
 ZXZnejVMbDZTQ0dIZ1Jya3lScG5TWWFVL3VMZ24zN042QVl4aS9RQUwKK2J5M0N5RUZManpX
 QUV2eVE4YnEzSXVjbjdKRWJoUy9KLy9kVXFMb2VVZjh0c0dpMDB6bXJJVFpZZUZZQVJoUQpN
 dHNmaXpJclZEdHoxaVBmL1pNcDVnUkJuaXlqcFhuMTMxY20zTTNndjZIclFzQUdubjhBSnJ1
 OEdEaTVYSllJCmNvLzEreC9xRWlOMm5DbGFBT3BiaHpOMmVVdlBEWTVXMHEzYkEvWnAybWZH
 NTJ2YlJJK3RRMEJyMUhkL3ZzbnQKVUhPOTAzbU1aZXAyTnpOM0JaNXFFdlB2RzRyVzVacTJE
 cHliV2JRclNtOW9iaUJLYjJoaGJuTmxiaUE4YW05bwpiaTVxYjJoaGJuTmxia0JqWVc1dmJt
 bGpZV3d1WTI5dFBva0NOd1FUQVFvQUlRVUNUbzBYV2dJYkF3VUxDUWdICkF3VVZDZ2tJQ3dV
 V0FnTUJBQUllQVFJWGdBQUtDUkFGTHpad0dOWEQySXRNRC85anliYzg3ZE00dUFIazZ5Tk0K
 TjBZL0JGbW10VFdWc09CaHFPbm9iNGkzOEJyRE8yQzFoUUNQQ1FlNExMczEvNHB0ZW92UXQ4
 QjJGeXJQVmp3Zwo3alpUSE5LNzRyNmxDQ1Z4eDN5dTFCN1U5UG80VlRrY3NsVmIxL3FtV3V4
 OFhXY040eXZrVHFsTCtHeHB5Sm45CjlaWmZmWEpjNk9oNlRtT2ZiS0d2TXV1djVhclNJQTNK
 SEZMZjlhTHZadEExaXNKVXI3cFM5YXBnOXVUVUdVcDcKd2ZWMFdUNlQzZUczbXRVVTJ1cDVK
 VjQ4NTBMMDVqSFM2dVdpZS9ZK3lmSk9iaXlyeE4vNlpxVzVHb25oTEJxLwptc3pjVjV2QlQz
 QkRWZTNSdkY2WGRNOU9oUG4xK1k4MXg1NCt2UTExM044aUx3RjdHR2ExNFp5SVZBTlpEMEkw
 CkhqUnZhMmsvUnFJUlR6S3l1UEg1cGtsY0tIVlBFRk1tT3pNVCtGT294Tmp2Uys3K3dHMktN
 RFlFbUhQcjFQSkIKWlNaZUh6SzE5dGZhbFBNcHBGeGkrc3lZTGFnTjBtQjdKSFF3WTdjclV1
 T0RoeWNxNjBZVnoxdGFFeWd1M1l2MgoyL0kxRUNHSHZLSEc2d2M5MG80M0MvZWxIRUNYbkVo
 N3RLcGxEY3BJQytPQ21NeEtIaFI0NitYY1p2Z3c0RGdiCjdjYTgzZVFSM0NHODlMdlFwVzJM
 TEtFRUJEajdoWmhrTGJra1BSWm0zdzhKWTQ0YXc4VnRneFdkblNFTUNMeEwKSU9OaDZ1Wjcv
 L0RZVnRjSWFNSllrZWJhWnRHZENwMElnVVpiMjQvVmR2WkNZYk82MkhrLzNWbzFuWHdIVUVz
 Mwo2RC92MWJUMFJaRmk2OUxnc0NjT2N4NGdZTGtDRFFST1pxejZBUkFBb3F3NmtrQmhXeU0x
 ZnZnYW1BVmplWjZuCktFZm5SV2JrQzk0TDFFc0pMdXAzV2IyWDBBQk5PSFNrYlNENHBBdUMy
 dEtGL0VHQnQ1Q1A3UWRWS1JHY1F6QWQKNmIyYzFJZHk5Ukx3Nnc0Z2krbm4vZDFQbTFra1lo
 a1NpNXpXYUlnMG01UlFVaytFbDh6a2Y1dGNFLzFOMFo1TwpLMkpoandGdTViWDBhMGw0Y0ZH
 V1ZRRWNpVk1ES1J0eE1qRXRrM1N4RmFsbTZaZFEycHAyODIyY2xucTR6WjltCld1MWQyd2F4
 aXorYjVJYTR3ZURZYTduNDFVUmNCRVViSkFnbmljSmtKdENUd3lJeElXMktuVnlPcmp2a1F6
 SUIKdmFQMEZkUDJ2dlpvUE1kbENJek9sSWtQTGd4RTBJV3VlVFhlQkpoTnMwMXBiOGJMcW1U
 SU1sdTRMdkJFTEEvdgplaWFqajVzOHk1NDJIL2FIc2ZCZjRNUVVoSHhPL0JaVjdoMDZLU1Vm
 SWFZN09nQWdLdUdOQjNVaWFJVVM1K2E5CmduRU9RTER4S1J5L2E3UTF2OVMrTnZ4KzdqOGlI
 M2prUUpoeFQ2WkJoWkdSeDBna0gzVCtGMG5ORG01TmFKVXMKYXN3Z0pycUZaa1VHZDJNcm0x
 cW5Ld1hpQXQ4U0ljRU5kcTMzUjBLS0tSQzgwWGd3ajhKbjMwdlhMU0crTk8xRwpIMFVNY0F4
 TXd5L3B2azZMVTVKR2paUjczSjVVTFZoSDRNTGJEZ2dEM21QYWlHOCtmb3RUckpVUHFxaGc5
 aHlVCkVQcFlHN3NxdDc0WG43OStDRVpjakxIenlsNnZBRkUyVzBreGxMdFF0VVpVSE8zNmFm
 RnY4cUdwTzNacVB2akIKVXVhdFhGNnR2VVFDd2YzSDZYTUFFUUVBQVlrQ0h3UVlBUW9BQ1FV
 Q1RtYXMrZ0liREFBS0NSQUZMelp3R05YRAoyRC9YRC8wZGRNLzRhaTFiK1RsMWp6bkthalgz
 a0crTWVFWWVJNGY0MHZjbzNyT0xyblJHRk9jYnl5ZlZGNjlNCktlcGllNE93b0kxamNUVTBB
 RGVjbmJXbkROSHByMFNjenhCTXJvM2Juckxoc212anVuVFlJdnNzQlp0QjRhVkoKanVMSUxQ
 VWxuaEZxYTdmYlZxMFpRamJpVi9ydDJqQkVOZG05cGJKWjZHam5wWUljQWJQQ0NhL2ZmTDQv
 U1FSUwpZSFhvaEdpaVM0eTVqQlRtSzVsdGZld0xPdzAyZmtleEgrSUpGcnJHQlhEU2c2bjJT
 Z3hubisrTkYzNGZYY205CnBpYXczbUtzSUNtKzBoZE5oNGFmR1o2SVdWOFBHMnRlb29WRHA0
 ZFlpaCsreFgvWFM4ekJDYzFPOXc0bnpsUDIKZ0t6bHFTV2JoaVdwaWZSSkJGYTRXdEFlSlRk
 WFlkMzdqL0JJNFJXV2hueXc3YUFQTkdqMzN5dEdITlVmNlJvMgovanRqNHRGMXkvUUZYcWpK
 Ry93R2pwZHRSZmJ0VWpxTEhJc3ZmUE5OSnEvOTU4cDc0bmRBQ2lkbFdTSHpqK09wCjI2S3Bi
 Rm5td05PMHBzaVVzbmh2SEZ3UE8vdkFibDNSc1I1KzBSbytodnMyY0VtUXV2OXIvYkRsQ2Zw
 enAydDMKY0srcmh4VXFpc094OERaZnoxQm5rYW9DUkZidnZ2ays3TC9mb21QbnRHUGtxSmNp
 WUU4VEdIa1p3MWhPa3UrNApPb00yR0I1bkVEbGorMlRGL2pMUStFaXBYOVBrUEpZdnhmUmxD
 NmRLOFBLS2ZYOUtkZm1BSWNnSGZuVjFqU24rCjh5SDJkakJQdEtpcVcwSjY5YUlzeXg3aVYv
 MDNwYVBDakpoN1hxOXZBenlkTjVVL1VBPT0KPTZQL2IKLS0tLS1FTkQgUEdQIFBVQkxJQyBL
 RVkgQkxPQ0stLS0tLQo=
Organization: Canonical
Message-ID: <76aa5e8d-4edf-9df7-c799-54a38a334231@canonical.com>
Date:   Tue, 28 Jul 2020 13:13:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724203226.16374-16-casey@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 1:32 PM, Casey Schaufler wrote:
> Replace the (secctx,seclen) pointer pair with a single
> lsmcontext pointer to allow return of the LSM identifier
> along with the context and context length. This allows
> security_release_secctx() to know how to release the
> context. Callers have been modified to use or save the
> returned data from the new structure.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Acked-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/android/binder.c                | 26 +++++++---------
>  include/linux/security.h                |  4 +--
>  include/net/scm.h                       | 10 ++-----
>  kernel/audit.c                          | 35 ++++++++--------------
>  kernel/auditsc.c                        | 31 +++++++------------
>  net/ipv4/ip_sockglue.c                  |  7 ++---
>  net/netfilter/nf_conntrack_netlink.c    | 18 +++++------
>  net/netfilter/nf_conntrack_standalone.c |  7 ++---
>  net/netfilter/nfnetlink_queue.c         |  5 +++-
>  net/netlabel/netlabel_unlabeled.c       | 40 ++++++++-----------------
>  net/netlabel/netlabel_user.c            |  7 ++---
>  security/security.c                     | 10 +++++--
>  12 files changed, 76 insertions(+), 124 deletions(-)
> 
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index b7ab206f8bb3..ceb5987c7d76 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -2861,9 +2861,7 @@ static void binder_transaction(struct binder_proc *proc,
>  	binder_size_t last_fixup_min_off = 0;
>  	struct binder_context *context = proc->context;
>  	int t_debug_id = atomic_inc_return(&binder_last_id);
> -	char *secctx = NULL;
> -	u32 secctx_sz = 0;
> -	struct lsmcontext scaff; /* scaffolding */
> +	struct lsmcontext lsmctx = { };
>  
>  	e = binder_transaction_log_add(&binder_transaction_log);
>  	e->debug_id = t_debug_id;
> @@ -3111,14 +3109,14 @@ static void binder_transaction(struct binder_proc *proc,
>  		size_t added_size;
>  
>  		security_task_getsecid(proc->tsk, &blob);
> -		ret = security_secid_to_secctx(&blob, &secctx, &secctx_sz);
> +		ret = security_secid_to_secctx(&blob, &lsmctx);
>  		if (ret) {
>  			return_error = BR_FAILED_REPLY;
>  			return_error_param = ret;
>  			return_error_line = __LINE__;
>  			goto err_get_secctx_failed;
>  		}
> -		added_size = ALIGN(secctx_sz, sizeof(u64));
> +		added_size = ALIGN(lsmctx.len, sizeof(u64));
>  		extra_buffers_size += added_size;
>  		if (extra_buffers_size < added_size) {
>  			/* integer overflow of extra_buffers_size */
> @@ -3145,24 +3143,22 @@ static void binder_transaction(struct binder_proc *proc,
>  		t->buffer = NULL;
>  		goto err_binder_alloc_buf_failed;
>  	}
> -	if (secctx) {
> +	if (lsmctx.context) {
>  		int err;
>  		size_t buf_offset = ALIGN(tr->data_size, sizeof(void *)) +
>  				    ALIGN(tr->offsets_size, sizeof(void *)) +
>  				    ALIGN(extra_buffers_size, sizeof(void *)) -
> -				    ALIGN(secctx_sz, sizeof(u64));
> +				    ALIGN(lsmctx.len, sizeof(u64));
>  
>  		t->security_ctx = (uintptr_t)t->buffer->user_data + buf_offset;
>  		err = binder_alloc_copy_to_buffer(&target_proc->alloc,
>  						  t->buffer, buf_offset,
> -						  secctx, secctx_sz);
> +						  lsmctx.context, lsmctx.len);
>  		if (err) {
>  			t->security_ctx = 0;
>  			WARN_ON(1);
>  		}
> -		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
> -		security_release_secctx(&scaff);
> -		secctx = NULL;
> +		security_release_secctx(&lsmctx);
>  	}
>  	t->buffer->debug_id = t->debug_id;
>  	t->buffer->transaction = t;
> @@ -3218,7 +3214,7 @@ static void binder_transaction(struct binder_proc *proc,
>  	off_end_offset = off_start_offset + tr->offsets_size;
>  	sg_buf_offset = ALIGN(off_end_offset, sizeof(void *));
>  	sg_buf_end_offset = sg_buf_offset + extra_buffers_size -
> -		ALIGN(secctx_sz, sizeof(u64));
> +		ALIGN(lsmctx.len, sizeof(u64));
>  	off_min = 0;
>  	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
>  	     buffer_offset += sizeof(binder_size_t)) {
> @@ -3494,10 +3490,8 @@ static void binder_transaction(struct binder_proc *proc,
>  	binder_alloc_free_buf(&target_proc->alloc, t->buffer);
>  err_binder_alloc_buf_failed:
>  err_bad_extra_size:
> -	if (secctx) {
> -		lsmcontext_init(&scaff, secctx, secctx_sz, 0);
> -		security_release_secctx(&scaff);
> -	}
> +	if (lsmctx.context)
> +		security_release_secctx(&lsmctx);
>  err_get_secctx_failed:
>  	kfree(tcomplete);
>  	binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
> diff --git a/include/linux/security.h b/include/linux/security.h
> index f67e4084b893..43f8a2660d37 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -553,7 +553,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
>  			 size_t size);
>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>  int security_ismaclabel(const char *name);
> -int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
> +int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
>  int security_secctx_to_secid(const char *secdata, u32 seclen,
>  			     struct lsmblob *blob);
>  void security_release_secctx(struct lsmcontext *cp);
> @@ -1371,7 +1371,7 @@ static inline int security_ismaclabel(const char *name)
>  }
>  
>  static inline int security_secid_to_secctx(struct lsmblob *blob,
> -					   char **secdata, u32 *seclen)
> +					   struct lsmcontext *cp)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/include/net/scm.h b/include/net/scm.h
> index 30ba801c91bd..4a6ad8caf423 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -93,18 +93,14 @@ static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
>  static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
>  {
>  	struct lsmcontext context;
> -	char *secdata;
> -	u32 seclen;
>  	int err;
>  
>  	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
> -		err = security_secid_to_secctx(&scm->lsmblob, &secdata,
> -					       &seclen);
> +		err = security_secid_to_secctx(&scm->lsmblob, &context);
>  
>  		if (!err) {
> -			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
> -			/*scaffolding*/
> -			lsmcontext_init(&context, secdata, seclen, 0);
> +			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY,
> +				 context.len, context.context);
>  			security_release_secctx(&context);
>  		}
>  	}
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 3378c773b1c1..d300e41ca443 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1186,9 +1186,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  	struct audit_buffer	*ab;
>  	u16			msg_type = nlh->nlmsg_type;
>  	struct audit_sig_info   *sig_data;
> -	char			*ctx = NULL;
> -	u32			len;
> -	struct lsmcontext	scaff; /* scaffolding */
> +	struct lsmcontext	context = { };
>  
>  	err = audit_netlink_ok(skb, msg_type);
>  	if (err)
> @@ -1430,30 +1428,26 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  		break;
>  	}
>  	case AUDIT_SIGNAL_INFO:
> -		len = 0;
>  		if (lsmblob_is_set(&audit_sig_lsm)) {
> -			err = security_secid_to_secctx(&audit_sig_lsm, &ctx,
> -						       &len);
> +			err = security_secid_to_secctx(&audit_sig_lsm,
> +						       &context);
>  			if (err)
>  				return err;
>  		}
> -		sig_data = kmalloc(sizeof(*sig_data) + len, GFP_KERNEL);
> +		sig_data = kmalloc(sizeof(*sig_data) + context.len, GFP_KERNEL);
>  		if (!sig_data) {
> -			if (lsmblob_is_set(&audit_sig_lsm)) {
> -				lsmcontext_init(&scaff, ctx, len, 0);
> -				security_release_secctx(&scaff);
> -			}
> +			if (lsmblob_is_set(&audit_sig_lsm))
> +				security_release_secctx(&context);
>  			return -ENOMEM;
>  		}
>  		sig_data->uid = from_kuid(&init_user_ns, audit_sig_uid);
>  		sig_data->pid = audit_sig_pid;
>  		if (lsmblob_is_set(&audit_sig_lsm)) {
> -			memcpy(sig_data->ctx, ctx, len);
> -			lsmcontext_init(&scaff, ctx, len, 0);
> -			security_release_secctx(&scaff);
> +			memcpy(sig_data->ctx, context.context, context.len);
> +			security_release_secctx(&context);
>  		}
>  		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
> -				 sig_data, sizeof(*sig_data) + len);
> +				 sig_data, sizeof(*sig_data) + context.len);

use after "free", move the security_release_secctx(&context) to after here



>  		kfree(sig_data);
>  		break;
>  	case AUDIT_TTY_GET: {
> @@ -2116,26 +2110,23 @@ void audit_log_key(struct audit_buffer *ab, char *key)
>  
>  int audit_log_task_context(struct audit_buffer *ab)
>  {
> -	char *ctx = NULL;
> -	unsigned len;
>  	int error;
>  	struct lsmblob blob;
> -	struct lsmcontext scaff; /* scaffolding */
> +	struct lsmcontext context;
>  
>  	security_task_getsecid(current, &blob);
>  	if (!lsmblob_is_set(&blob))
>  		return 0;
>  
> -	error = security_secid_to_secctx(&blob, &ctx, &len);
> +	error = security_secid_to_secctx(&blob, &context);
>  	if (error) {
>  		if (error != -EINVAL)
>  			goto error_path;
>  		return 0;
>  	}
>  
> -	audit_log_format(ab, " subj=%s", ctx);
> -	lsmcontext_init(&scaff, ctx, len, 0);
> -	security_release_secctx(&scaff);
> +	audit_log_format(ab, " subj=%s", context.context);
> +	security_release_secctx(&context);
>  	return 0;
>  
>  error_path:
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index ac6836c1f2d3..1f7bd6b34ec7 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -980,9 +980,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
>  				 struct lsmblob *blob, char *comm)
>  {
>  	struct audit_buffer *ab;
> -	struct lsmcontext lsmcxt;
> -	char *ctx = NULL;
> -	u32 len;
> +	struct lsmcontext lsmctx;
>  	int rc = 0;
>  
>  	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
> @@ -993,13 +991,12 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
>  			 from_kuid(&init_user_ns, auid),
>  			 from_kuid(&init_user_ns, uid), sessionid);
>  	if (lsmblob_is_set(blob)) {
> -		if (security_secid_to_secctx(blob, &ctx, &len)) {
> +		if (security_secid_to_secctx(blob, &lsmctx)) {
>  			audit_log_format(ab, " obj=(none)");
>  			rc = 1;
>  		} else {
> -			audit_log_format(ab, " obj=%s", ctx);
> -			lsmcontext_init(&lsmcxt, ctx, len, 0); /*scaffolding*/
> -			security_release_secctx(&lsmcxt);
> +			audit_log_format(ab, " obj=%s", lsmctx.context);
> +			security_release_secctx(&lsmctx);
>  		}
>  	}
>  	audit_log_format(ab, " ocomm=");
> @@ -1212,7 +1209,6 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
>  
>  static void show_special(struct audit_context *context, int *call_panic)
>  {
> -	struct lsmcontext lsmcxt;
>  	struct audit_buffer *ab;
>  	int i;
>  
> @@ -1236,17 +1232,15 @@ static void show_special(struct audit_context *context, int *call_panic)
>  				 from_kgid(&init_user_ns, context->ipc.gid),
>  				 context->ipc.mode);
>  		if (osid) {
> -			char *ctx = NULL;
> -			u32 len;
> +			struct lsmcontext lsmcxt;
>  			struct lsmblob blob;
>  
>  			lsmblob_init(&blob, osid);
> -			if (security_secid_to_secctx(&blob, &ctx, &len)) {
> +			if (security_secid_to_secctx(&blob, &lsmcxt)) {
>  				audit_log_format(ab, " osid=%u", osid);
>  				*call_panic = 1;
>  			} else {
> -				audit_log_format(ab, " obj=%s", ctx);
> -				lsmcontext_init(&lsmcxt, ctx, len, 0);
> +				audit_log_format(ab, " obj=%s", lsmcxt.context);
>  				security_release_secctx(&lsmcxt);
>  			}
>  		}
> @@ -1390,20 +1384,17 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
>  				 MAJOR(n->rdev),
>  				 MINOR(n->rdev));
>  	if (n->osid != 0) {
> -		char *ctx = NULL;
> -		u32 len;
>  		struct lsmblob blob;
> -		struct lsmcontext lsmcxt;
> +		struct lsmcontext lsmctx;
>  
>  		lsmblob_init(&blob, n->osid);
> -		if (security_secid_to_secctx(&blob, &ctx, &len)) {
> +		if (security_secid_to_secctx(&blob, &lsmctx)) {
>  			audit_log_format(ab, " osid=%u", n->osid);
>  			if (call_panic)
>  				*call_panic = 2;
>  		} else {
> -			audit_log_format(ab, " obj=%s", ctx);
> -			lsmcontext_init(&lsmcxt, ctx, len, 0); /* scaffolding */
> -			security_release_secctx(&lsmcxt);
> +			audit_log_format(ab, " obj=%s", lsmctx.context);
> +			security_release_secctx(&lsmctx);
>  		}
>  	}
>  
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index 6391a570f9ad..176ac9ce6069 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -132,20 +132,17 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
>  {
>  	struct lsmcontext context;
>  	struct lsmblob lb;
> -	char *secdata;
> -	u32 seclen;
>  	int err;
>  
>  	err = security_socket_getpeersec_dgram(NULL, skb, &lb);
>  	if (err)
>  		return;
>  
> -	err = security_secid_to_secctx(&lb, &secdata, &seclen);
> +	err = security_secid_to_secctx(&lb, &context);
>  	if (err)
>  		return;
>  
> -	put_cmsg(msg, SOL_IP, SCM_SECURITY, seclen, secdata);
> -	lsmcontext_init(&context, secdata, seclen, 0); /* scaffolding */
> +	put_cmsg(msg, SOL_IP, SCM_SECURITY, context.len, context.context);
>  	security_release_secctx(&context);
>  }
>  
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 1c45ca8c3c21..e38b5182e301 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -331,8 +331,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
>  static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
>  {
>  	struct nlattr *nest_secctx;
> -	int len, ret;
> -	char *secctx;
> +	int ret;
>  	struct lsmblob blob;
>  	struct lsmcontext context;
>  
> @@ -340,7 +339,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
>  	 * security_secid_to_secctx() will know which security module
>  	 * to use to create the secctx.  */
>  	lsmblob_init(&blob, ct->secmark);
> -	ret = security_secid_to_secctx(&blob, &secctx, &len);
> +	ret = security_secid_to_secctx(&blob, &context);
>  	if (ret)
>  		return 0;
>  
> @@ -349,13 +348,12 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
>  	if (!nest_secctx)
>  		goto nla_put_failure;
>  
> -	if (nla_put_string(skb, CTA_SECCTX_NAME, secctx))
> +	if (nla_put_string(skb, CTA_SECCTX_NAME, context.context))
>  		goto nla_put_failure;
>  	nla_nest_end(skb, nest_secctx);
>  
>  	ret = 0;
>  nla_put_failure:
> -	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
>  	security_release_secctx(&context);
>  	return ret;
>  }
> @@ -655,15 +653,15 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
>  #ifdef CONFIG_NF_CONNTRACK_SECMARK
>  	int len, ret;
>  	struct lsmblob blob;
> +	struct lsmcontext context;
>  
> -	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
> -	 * security_secid_to_secctx() will know which security module
> -	 * to use to create the secctx.  */
> -	lsmblob_init(&blob, ct->secmark);
> -	ret = security_secid_to_secctx(&blob, NULL, &len);
> +	ret = security_secid_to_secctx(&blob, &context);
>  	if (ret)
>  		return 0;
>  
> +	len = context.len;
> +	security_release_secctx(&context);
> +
>  	return nla_total_size(0) /* CTA_SECCTX */
>  	       + nla_total_size(sizeof(char) * len); /* CTA_SECCTX_NAME */
>  #else
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index fd01d778c295..0ecd1040f4f1 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -173,19 +173,16 @@ static void ct_seq_stop(struct seq_file *s, void *v)
>  static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
>  {
>  	int ret;
> -	u32 len;
> -	char *secctx;
>  	struct lsmblob blob;
>  	struct lsmcontext context;
>  
>  	lsmblob_init(&blob, ct->secmark);
> -	ret = security_secid_to_secctx(&blob, &secctx, &len);
> +	ret = security_secid_to_secctx(&blob, &context);
>  	if (ret)
>  		return;
>  
> -	seq_printf(s, "secctx=%s ", secctx);
> +	seq_printf(s, "secctx=%s ", context.context);
>  
> -	lsmcontext_init(&context, secctx, len, 0); /* scaffolding */
>  	security_release_secctx(&context);
>  }
>  #else
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index c89bd87d0dae..fe19ae7216db 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -306,6 +306,7 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
>  	u32 seclen = 0;
>  #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
>  	struct lsmblob blob;
> +	struct lsmcontext context = { };
>  
>  	if (!skb || !sk_fullsock(skb->sk))
>  		return 0;
> @@ -317,10 +318,12 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
>  		 * blob. security_secid_to_secctx() will know which security
>  		 * module to use to create the secctx.  */
>  		lsmblob_init(&blob, skb->secmark);
> -		security_secid_to_secctx(&blob, secdata, &seclen);
> +		security_secid_to_secctx(&blob, &context);
> +		*secdata = context.context;
>  	}
>  
>  	read_unlock_bh(&skb->sk->sk_callback_lock);
> +	seclen = context.len;
>  #endif
>  	return seclen;
>  }
> diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
> index 5785e6dcf54b..cf4c56beb3ec 100644
> --- a/net/netlabel/netlabel_unlabeled.c
> +++ b/net/netlabel/netlabel_unlabeled.c
> @@ -375,8 +375,6 @@ int netlbl_unlhsh_add(struct net *net,
>  	struct netlbl_unlhsh_iface *iface;
>  	struct audit_buffer *audit_buf = NULL;
>  	struct lsmcontext context;
> -	char *secctx = NULL;
> -	u32 secctx_len;
>  	struct lsmblob blob;
>  
>  	if (addr_len != sizeof(struct in_addr) &&
> @@ -444,12 +442,9 @@ int netlbl_unlhsh_add(struct net *net,
>  		 * security_secid_to_secctx() will know which security module
>  		 * to use to create the secctx.  */
>  		lsmblob_init(&blob, secid);
> -		if (security_secid_to_secctx(&blob,
> -					     &secctx,
> -					     &secctx_len) == 0) {
> -			audit_log_format(audit_buf, " sec_obj=%s", secctx);
> -			/* scaffolding */
> -			lsmcontext_init(&context, secctx, secctx_len, 0);
> +		if (security_secid_to_secctx(&blob, &context) == 0) {
> +			audit_log_format(audit_buf, " sec_obj=%s",
> +					 context.context);
>  			security_release_secctx(&context);
>  		}
>  		audit_log_format(audit_buf, " res=%u", ret_val == 0 ? 1 : 0);
> @@ -482,8 +477,6 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
>  	struct audit_buffer *audit_buf;
>  	struct net_device *dev;
>  	struct lsmcontext context;
> -	char *secctx;
> -	u32 secctx_len;
>  	struct lsmblob blob;
>  
>  	spin_lock(&netlbl_unlhsh_lock);
> @@ -510,11 +503,9 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
>  		if (entry != NULL)
>  			lsmblob_init(&blob, entry->secid);
>  		if (entry != NULL &&
> -		    security_secid_to_secctx(&blob,
> -					     &secctx, &secctx_len) == 0) {
> -			audit_log_format(audit_buf, " sec_obj=%s", secctx);
> -			/* scaffolding */
> -			lsmcontext_init(&context, secctx, secctx_len, 0);
> +		    security_secid_to_secctx(&blob, &context) == 0) {
> +			audit_log_format(audit_buf, " sec_obj=%s",
> +					 context.context);
>  			security_release_secctx(&context);
>  		}
>  		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
> @@ -553,8 +544,6 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
>  	struct audit_buffer *audit_buf;
>  	struct net_device *dev;
>  	struct lsmcontext context;
> -	char *secctx;
> -	u32 secctx_len;
>  	struct lsmblob blob;
>  
>  	spin_lock(&netlbl_unlhsh_lock);
> @@ -580,10 +569,9 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
>  		if (entry != NULL)
>  			lsmblob_init(&blob, entry->secid);
>  		if (entry != NULL &&
> -		    security_secid_to_secctx(&blob,
> -					     &secctx, &secctx_len) == 0) {
> -			audit_log_format(audit_buf, " sec_obj=%s", secctx);
> -			lsmcontext_init(&context, secctx, secctx_len, 0);
> +		    security_secid_to_secctx(&blob, &context) == 0) {
> +			audit_log_format(audit_buf, " sec_obj=%s",
> +					 context.context);
>  			security_release_secctx(&context);
>  		}
>  		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
> @@ -1106,8 +1094,6 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
>  	struct lsmcontext context;
>  	void *data;
>  	u32 secid;
> -	char *secctx;
> -	u32 secctx_len;
>  	struct lsmblob blob;
>  
>  	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
> @@ -1167,15 +1153,13 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
>           * security_secid_to_secctx() will know which security module
>           * to use to create the secctx.  */
>  	lsmblob_init(&blob, secid);
> -	ret_val = security_secid_to_secctx(&blob, &secctx, &secctx_len);
> +	ret_val = security_secid_to_secctx(&blob, &context);
>  	if (ret_val != 0)
>  		goto list_cb_failure;
>  	ret_val = nla_put(cb_arg->skb,
>  			  NLBL_UNLABEL_A_SECCTX,
> -			  secctx_len,
> -			  secctx);
> -	/* scaffolding */
> -	lsmcontext_init(&context, secctx, secctx_len, 0);
> +			  context.len,
> +			  context.context);
>  	security_release_secctx(&context);
>  	if (ret_val != 0)
>  		goto list_cb_failure;
> diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
> index ef139d8ae7cd..951ba0639d20 100644
> --- a/net/netlabel/netlabel_user.c
> +++ b/net/netlabel/netlabel_user.c
> @@ -85,8 +85,6 @@ struct audit_buffer *netlbl_audit_start_common(int type,
>  {
>  	struct audit_buffer *audit_buf;
>  	struct lsmcontext context;
> -	char *secctx;
> -	u32 secctx_len;
>  	struct lsmblob blob;
>  
>  	if (audit_enabled == AUDIT_OFF)
> @@ -102,9 +100,8 @@ struct audit_buffer *netlbl_audit_start_common(int type,
>  
>  	lsmblob_init(&blob, audit_info->secid);
>  	if (audit_info->secid != 0 &&
> -	    security_secid_to_secctx(&blob, &secctx, &secctx_len) == 0) {
> -		audit_log_format(audit_buf, " subj=%s", secctx);
> -		lsmcontext_init(&context, secctx, secctx_len, 0);/*scaffolding*/
> +	    security_secid_to_secctx(&blob, &context) == 0) {
> +		audit_log_format(audit_buf, " subj=%s", context.context);
>  		security_release_secctx(&context);
>  	}
>  
> diff --git a/security/security.c b/security/security.c
> index a6d0b6851a66..862f0bc2f114 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2191,18 +2191,22 @@ int security_ismaclabel(const char *name)
>  }
>  EXPORT_SYMBOL(security_ismaclabel);
>  
> -int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen)
> +int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp)
>  {
>  	struct security_hook_list *hp;
>  	int display = lsm_task_display(current);
>  
> +	memset(cp, 0, sizeof(*cp));
> +
>  	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
>  		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
>  			continue;
> -		if (display == LSMBLOB_INVALID || display == hp->lsmid->slot)
> +		if (display == LSMBLOB_INVALID || display == hp->lsmid->slot) {
> +			cp->slot = hp->lsmid->slot;
>  			return hp->hook.secid_to_secctx(
>  					blob->secid[hp->lsmid->slot],
> -					secdata, seclen);
> +					&cp->context, &cp->len);
> +		}
>  	}
>  
>  	return LSM_RET_DEFAULT(secid_to_secctx);
> 

