Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537A56AFB68
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCHAlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjCHAlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:41:07 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E532B06EA;
        Tue,  7 Mar 2023 16:40:40 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-53852143afcso277492397b3.3;
        Tue, 07 Mar 2023 16:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678236039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rfo1qZ3pkzFGNnScMkA66cAh3z1bEGK9olcROqT2/A=;
        b=ktfUs99lrSAqqVak3YmhW/91qA4RlBEMnEV2iKPsLYE1jU7OYUWmnXpYA6f/o2ZYeN
         RtThRTR7lT8xyDwbnxvYFtK8aXt2WnNNozNAvJUmH9JLB8HbeaqWi4zCk19zcOCvHY/m
         SawVw64lgVqaxvnzZ7rf2QU2bYwf6CvAs4zTZrSPeuhh+pJZ+vhasGwU8OROdrQ+mu5O
         KAQO2CkWBpN4+vp8BqHIJJj5Yt5BIU+bgkyKPeLEgQY9L8oV5s4eqzA35uak4nMkN1/x
         720eaJK4yWnLZSNHwGePXALaQYNq+w2P8O/CBp8Q5x0i9tiePqj5nczA5d1j9lKQL+e+
         x+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678236039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8rfo1qZ3pkzFGNnScMkA66cAh3z1bEGK9olcROqT2/A=;
        b=O+qTyKL7nrCuVRolDhPXEZdOVo75Xebh+UiynNH4kHle/4wNPVuC4WQDDAMdMJJcUU
         jsMyvwno/8lvqtFnxYQ/frc+EvnP4X6tysAAcbpXBvLUd3caGJch1H1+ZHvgCEzM1sxh
         pxuc0AqSBU0Gv0QNHORFBnlN0Q2NMlhDXY616UOi/MhZ/cM3wen+dYAkKIjYfc1NNzEn
         W6dJXHdMhdHGnZn6CvumU5+t+us3+pBoU3z8YXJtaspEmU/gzRO4uuZoYzT+1wObZ6Jx
         bkV4/+Kq22tBXJ51Dt7+tu2RnNzuBmbxFASi7B4N1RHR/OJIgspwcJunNbYvOmLPrCmL
         zBgg==
X-Gm-Message-State: AO0yUKU6u1ce9atSH00vLyITotbmBSeZrVU3QCtSr7QW8QwpHGZA7YSE
        QtObcBgcDcpbvj2vvn9Z6foKRkNHu74PNaHu430=
X-Google-Smtp-Source: AK7set/pbhAAL2gbOk96qiA+YpPodgvSWVQJAhLYmlep2/8RkK+ONxpcpjxAuG19chxMIEJ0eEZaTiScvJOojxU3uMg=
X-Received: by 2002:a81:4428:0:b0:533:8b3a:d732 with SMTP id
 r40-20020a814428000000b005338b3ad732mr9877504ywa.4.1678236039461; Tue, 07 Mar
 2023 16:40:39 -0800 (PST)
MIME-Version: 1.0
References: <20230306210312.2614988-1-vernon2gm@gmail.com> <20230306210312.2614988-4-vernon2gm@gmail.com>
In-Reply-To: <20230306210312.2614988-4-vernon2gm@gmail.com>
From:   Justin Tee <justintee8345@gmail.com>
Date:   Tue, 7 Mar 2023 16:40:28 -0800
Message-ID: <CABPRKS-DRvmZpoXBTogjEf5Q+oL5GR71nSVRgmVo5vWx-9OQow@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] scsi: lpfc: fix lpfc_cpu_affinity_check() if no
 further cpus set
To:     Vernon Yang <vernon2gm@gmail.com>
Cc:     torvalds@linux-foundation.org, tytso@mit.edu, Jason@zx2c4.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vernon,

Is it possible to move the new helper routine lpfc_next_present_cpu
into the lpfc.h header file around where lpfc_next_online_cpu is
defined?

Also, with slight modifications we could use the new
lpfc_next_present_cpu helper routine for the
lpfc_nvmet_setup_io_context() patch as well so that we can contain all
lpfc changes within one patch.

---
 drivers/scsi/lpfc/lpfc.h       | 20 ++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c  | 31 +++++++------------------------
 drivers/scsi/lpfc/lpfc_nvmet.c |  5 +----
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index cf55f8e3bd9f..f342d6bc5726 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1737,6 +1737,26 @@ lpfc_next_online_cpu(const struct cpumask
*mask, unsigned int start)

     return cpu_it;
 }
+
+/**
+ * lpfc_next_present_cpu - Finds next present CPU after n
+ * @n: the cpu prior to search
+ *
+ * Note: If no next present cpu, then fallback to first present cpu.
+ *
+ **/
+static inline unsigned int lpfc_next_present_cpu(int n)
+{
+    unsigned int cpu;
+
+    cpu =3D cpumask_next(n, cpu_present_mask);
+
+    if (cpu >=3D nr_cpu_ids)
+        cpu =3D cpumask_first(cpu_present_mask);
+
+    return cpu;
+}
+
 /**
  * lpfc_sli4_mod_hba_eq_delay - update EQ delay
  * @phba: Pointer to HBA context object.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3e1e1d17b2b4..f28af338341f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12560,10 +12560,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba
*phba, int vectors)
                     (new_cpup->eq !=3D LPFC_VECTOR_MAP_EMPTY) &&
                     (new_cpup->phys_id =3D=3D cpup->phys_id))
                     goto found_same;
-                new_cpu =3D cpumask_next(
-                    new_cpu, cpu_present_mask);
-                if (new_cpu =3D=3D nr_cpumask_bits)
-                    new_cpu =3D first_cpu;
+                new_cpu =3D lpfc_next_present_cpu(new_cpu);
             }
             /* At this point, we leave the CPU as unassigned */
             continue;
@@ -12575,9 +12572,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba,
int vectors)
              * chance of having multiple unassigned CPU entries
              * selecting the same IRQ.
              */
-            start_cpu =3D cpumask_next(new_cpu, cpu_present_mask);
-            if (start_cpu =3D=3D nr_cpumask_bits)
-                start_cpu =3D first_cpu;
+            start_cpu =3D lpfc_next_present_cpu(new_cpu);

             lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
                     "3337 Set Affinity: CPU %d "
@@ -12610,10 +12605,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba
*phba, int vectors)
                 if (!(new_cpup->flag & LPFC_CPU_MAP_UNASSIGN) &&
                     (new_cpup->eq !=3D LPFC_VECTOR_MAP_EMPTY))
                     goto found_any;
-                new_cpu =3D cpumask_next(
-                    new_cpu, cpu_present_mask);
-                if (new_cpu =3D=3D nr_cpumask_bits)
-                    new_cpu =3D first_cpu;
+                new_cpu =3D lpfc_next_present_cpu(new_cpu);
             }
             /* We should never leave an entry unassigned */
             lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -12629,9 +12621,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba,
int vectors)
              * chance of having multiple unassigned CPU entries
              * selecting the same IRQ.
              */
-            start_cpu =3D cpumask_next(new_cpu, cpu_present_mask);
-            if (start_cpu =3D=3D nr_cpumask_bits)
-                start_cpu =3D first_cpu;
+            start_cpu =3D lpfc_next_present_cpu(new_cpu);

             lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
                     "3338 Set Affinity: CPU %d "
@@ -12702,9 +12692,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba,
int vectors)
                 new_cpup->core_id =3D=3D cpup->core_id) {
                 goto found_hdwq;
             }
-            new_cpu =3D cpumask_next(new_cpu, cpu_present_mask);
-            if (new_cpu =3D=3D nr_cpumask_bits)
-                new_cpu =3D first_cpu;
+            new_cpu =3D lpfc_next_present_cpu(new_cpu);
         }

         /* If we can't match both phys_id and core_id,
@@ -12716,10 +12704,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba
*phba, int vectors)
             if (new_cpup->hdwq !=3D LPFC_VECTOR_MAP_EMPTY &&
                 new_cpup->phys_id =3D=3D cpup->phys_id)
                 goto found_hdwq;
-
-            new_cpu =3D cpumask_next(new_cpu, cpu_present_mask);
-            if (new_cpu =3D=3D nr_cpumask_bits)
-                new_cpu =3D first_cpu;
+            new_cpu =3D lpfc_next_present_cpu(new_cpu);
         }

         /* Otherwise just round robin on cfg_hdw_queue */
@@ -12728,9 +12713,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba,
int vectors)
         goto logit;
  found_hdwq:
         /* We found an available entry, copy the IRQ info */
-        start_cpu =3D cpumask_next(new_cpu, cpu_present_mask);
-        if (start_cpu =3D=3D nr_cpumask_bits)
-            start_cpu =3D first_cpu;
+        start_cpu =3D lpfc_next_present_cpu(new_cpu);
         cpup->hdwq =3D new_cpup->hdwq;
  logit:
         lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.=
c
index 7517dd55fe91..2d8ac2ceb6f3 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1620,10 +1620,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
             cpu =3D cpumask_first(cpu_present_mask);
             continue;
         }
-        cpu =3D cpumask_next(cpu, cpu_present_mask);
-        if (cpu =3D=3D nr_cpu_ids)
-            cpu =3D cpumask_first(cpu_present_mask);
-
+        cpu =3D lpfc_next_present_cpu(cpu);
     }

     for_each_present_cpu(i) {
--=20
2.38.0

Thanks,
Justin

On Mon, Mar 6, 2023 at 1:10=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> wr=
ote:
>
> When cpumask_next() the return value is greater than or equal to
> nr_cpu_ids, it indicates invalid.
>
> Before commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
> optimizations"), when cpumask_next() returned an invalid cpu, the driver
> used the judgment equal to nr_cpu_ids to indicate the invalid cpu, so it
> happened to work normally, but this is the wrong approach.
>
> After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
> optimizations"), these incorrect practices actively buggy, so fix it to
> correctly.
>
> Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 43 ++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.=
c
> index 61958a24a43d..acfffdbe9ba1 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -12473,6 +12473,16 @@ lpfc_hba_eq_hdl_array_init(struct lpfc_hba *phba=
)
>         }
>  }
>
> +static inline int lpfc_next_present_cpu(int n, int first_cpu)
> +{
> +       n =3D cpumask_next(n, cpu_present_mask);
> +
> +       if (n >=3D nr_cpu_ids)
> +               n =3D first_cpu;
> +
> +       return n;
> +}
> +
>  /**
>   * lpfc_cpu_affinity_check - Check vector CPU affinity mappings
>   * @phba: pointer to lpfc hba data structure.
> @@ -12561,10 +12571,8 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, i=
nt vectors)
>                                     (new_cpup->eq !=3D LPFC_VECTOR_MAP_EM=
PTY) &&
>                                     (new_cpup->phys_id =3D=3D cpup->phys_=
id))
>                                         goto found_same;
> -                               new_cpu =3D cpumask_next(
> -                                       new_cpu, cpu_present_mask);
> -                               if (new_cpu =3D=3D nr_cpumask_bits)
> -                                       new_cpu =3D first_cpu;
> +
> +                               new_cpu =3D lpfc_next_present_cpu(new_cpu=
, first_cpu);
>                         }
>                         /* At this point, we leave the CPU as unassigned =
*/
>                         continue;
> @@ -12576,9 +12584,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, in=
t vectors)
>                          * chance of having multiple unassigned CPU entri=
es
>                          * selecting the same IRQ.
>                          */
> -                       start_cpu =3D cpumask_next(new_cpu, cpu_present_m=
ask);
> -                       if (start_cpu =3D=3D nr_cpumask_bits)
> -                               start_cpu =3D first_cpu;
> +                       start_cpu =3D lpfc_next_present_cpu(new_cpu, firs=
t_cpu);
>
>                         lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>                                         "3337 Set Affinity: CPU %d "
> @@ -12611,10 +12617,8 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, i=
nt vectors)
>                                 if (!(new_cpup->flag & LPFC_CPU_MAP_UNASS=
IGN) &&
>                                     (new_cpup->eq !=3D LPFC_VECTOR_MAP_EM=
PTY))
>                                         goto found_any;
> -                               new_cpu =3D cpumask_next(
> -                                       new_cpu, cpu_present_mask);
> -                               if (new_cpu =3D=3D nr_cpumask_bits)
> -                                       new_cpu =3D first_cpu;
> +
> +                               new_cpu =3D lpfc_next_present_cpu(new_cpu=
, first_cpu);
>                         }
>                         /* We should never leave an entry unassigned */
>                         lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> @@ -12630,9 +12634,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, in=
t vectors)
>                          * chance of having multiple unassigned CPU entri=
es
>                          * selecting the same IRQ.
>                          */
> -                       start_cpu =3D cpumask_next(new_cpu, cpu_present_m=
ask);
> -                       if (start_cpu =3D=3D nr_cpumask_bits)
> -                               start_cpu =3D first_cpu;
> +                       start_cpu =3D lpfc_next_present_cpu(new_cpu, firs=
t_cpu);
>
>                         lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>                                         "3338 Set Affinity: CPU %d "
> @@ -12703,9 +12705,8 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, in=
t vectors)
>                             new_cpup->core_id =3D=3D cpup->core_id) {
>                                 goto found_hdwq;
>                         }
> -                       new_cpu =3D cpumask_next(new_cpu, cpu_present_mas=
k);
> -                       if (new_cpu =3D=3D nr_cpumask_bits)
> -                               new_cpu =3D first_cpu;
> +
> +                       new_cpu =3D lpfc_next_present_cpu(new_cpu, first_=
cpu);
>                 }
>
>                 /* If we can't match both phys_id and core_id,
> @@ -12718,9 +12719,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, in=
t vectors)
>                             new_cpup->phys_id =3D=3D cpup->phys_id)
>                                 goto found_hdwq;
>
> -                       new_cpu =3D cpumask_next(new_cpu, cpu_present_mas=
k);
> -                       if (new_cpu =3D=3D nr_cpumask_bits)
> -                               new_cpu =3D first_cpu;
> +                       new_cpu =3D lpfc_next_present_cpu(new_cpu, first_=
cpu);
>                 }
>
>                 /* Otherwise just round robin on cfg_hdw_queue */
> @@ -12729,9 +12728,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, in=
t vectors)
>                 goto logit;
>   found_hdwq:
>                 /* We found an available entry, copy the IRQ info */
> -               start_cpu =3D cpumask_next(new_cpu, cpu_present_mask);
> -               if (start_cpu =3D=3D nr_cpumask_bits)
> -                       start_cpu =3D first_cpu;
> +               start_cpu =3D lpfc_next_present_cpu(new_cpu, first_cpu);
>                 cpup->hdwq =3D new_cpup->hdwq;
>   logit:
>                 lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> --
> 2.34.1
>
